import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mnm_vendor/models/categories_model.dart';
import 'package:mnm_vendor/screens/upload_id_page.dart';
import 'package:mnm_vendor/utils/add_store.dart';
import 'package:mnm_vendor/utils/providers/categories_state_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddStorePage extends ConsumerStatefulWidget {
  const AddStorePage({super.key});
  static const routeName = '/add-a-store';

  @override
  AddStorePageState createState() => AddStorePageState();
}

class AddStorePageState extends ConsumerState<AddStorePage> {
  late GoogleMapController mapController;

  // To store the user's current location
  LatLng? _currentPosition;

  // To store the selected location
  LatLng? _selectedLocation;

  // List to hold the markers
  Set<Marker> _markers = {};

  // Controllers for the form fields
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _storePhoneController = TextEditingController();

  final TextEditingController _controller = TextEditingController();
  CategoryModel? _selectedCategory;
  String storeAddress = '';
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _saveBusinessInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('BusinessName', _businessNameController.text);
    sharedPreferences.setString('BusinessType', _businessTypeController.text);
    sharedPreferences.setDouble('lat', _selectedLocation!.latitude);
    sharedPreferences.setDouble('long', _selectedLocation!.longitude);
  }

  Future<void> _getCurrentLocation() async {
    // Request location permission
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } else {
      // Handle the case where the user denied the permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 15),
        ),
      );
    }
  }

  // Function to handle long press to place a pin (marker)
  void _onLongPress(LatLng position) {
    setState(() {
      _selectedLocation = position;
      _markers = {
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: 'Pinned Location',
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      };
    });
  }

  bool isLoading = false;

  Future<void> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
        setState(() {
          storeAddress = address;
        });
        print("Address: $address");
        // You can use this address to update the UI or perform other tasks
      }
    } catch (e) {
      print("Failed to get address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final responseMessage = ref.watch(storeResponseProvider);
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register your business',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please fill in the details below to register your account with us.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            // Business name field
            TextField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Business name',
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
            ),

            // GooglePlaceAutoCompleteTextField(
            //     textEditingController: _controller,
            //     googleAPIKey: "AIzaSyA2c9JnAfwmLnn98nCVHELAbLDiy8jM_cM",
            //     inputDecoration: const InputDecoration(),
            //     debounceTime: 800, // default 600 ms,
            //     countries: const [
            //       "in",
            //       "fr"
            //     ], // optional by default null is set
            //     isLatLngRequired:
            //         true, // if you required coordinates from place detail
            //     getPlaceDetailWithLatLng: (Prediction prediction) {
            //       // this method will return latlng with place detail
            //       print("placeDetails${prediction.lng}");
            //     }, // this callback is called when isLatLngRequired is true
            //     itemClick: (Prediction prediction) {
            //       _controller.text = prediction.description!;
            //       _controller.selection = TextSelection.fromPosition(
            //           TextPosition(offset: prediction.description!.length));
            //     },
            //     itemBuilder: (context, index, Prediction prediction) {
            //       return Container(
            //         padding: const EdgeInsets.all(10),
            //         child: Row(
            //           children: [
            //             const Icon(Icons.location_on),
            //             const SizedBox(
            //               width: 7,
            //             ),
            //             Expanded(child: Text(prediction.description ?? ""))
            //           ],
            //         ),
            //       );
            //     }),
            const SizedBox(height: 16),
            // Business type dropdown
            categoriesAsyncValue.when(
                data: (types) => DropdownButtonFormField<CategoryModel>(
                      items: types
                          .map((type) => DropdownMenuItem<CategoryModel>(
                                value: type,
                                child: Text(type.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        _selectedCategory = value;
                        if (_selectedCategory != null) {
                          print(
                              'Selected Category ID: ${_selectedCategory!.id}'); // Access the ID of the selected category
                        }
                        // _businessTypeController.text = value! as String;
                      },
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Business type',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                    ),
                error: (error, stack) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Error loading business types'),
                        IconButton(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: const Icon(Icons.replay_outlined))
                      ],
                    ),
                loading: () => const NutsActivityIndicator()),

            const SizedBox(height: 16),
            TextField(
              controller: _storePhoneController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Store Phone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            // Business location
            const SizedBox(height: 16),
            const Text(
              'Business location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Tap on the map to search for precise location'),
            const SizedBox(height: 8),
            // Map section
            SizedBox(
              height: 900,
              child: _currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition ??
                            const LatLng(40.712776,
                                -74.005974), // Default if location fails
                        zoom: 5.0,
                      ),
                      markers: _markers,
                      onLongPress:
                          _onLongPress, // Allow user to pin location on long press
                      myLocationEnabled: true, // Enable 'My Location' button
                    ),
            ),
            const SizedBox(height: 16),
            // Submit button
            SizedBox(
                width: double.infinity,
                child: CustomButton(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? token = prefs.getString('token');

                      if (_selectedLocation != null &&
                          _businessNameController.text.isNotEmpty &&
                          _selectedCategory != null &&
                          _storePhoneController.text.isNotEmpty) {
                        print('triggered');
                        try {
                          await getAddressFromCoordinates(
                              _selectedLocation!.latitude,
                              _selectedLocation!.longitude);
                          setState(() {
                            isLoading = true;
                          });
                          print(isLoading);
                          await StoreService.addStore(
                              onComplete: () {},
                              contxt: context,
                              startTime: '',
                              endTime: '',
                              token: token!,
                              images: [{}],
                              storeName: _businessNameController.text,
                              latitude: _selectedLocation!.latitude,
                              longitude: _selectedLocation!.longitude,
                              storePhone: _storePhoneController.text,
                              storeAddress: storeAddress,
                              type: _selectedCategory!.id,
                              ref: ref);

                          showCustomSnackbar(
                              context: context,
                              message: 'store successfully added');
                          Navigator.pushReplacementNamed(
                              context, IDVerificationScreen.routeName);
                        } catch (e) {
                          showCustomSnackbar(
                              context: context, message: e.toString());
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please select a location on the map'),
                          ),
                        );
                      }
                    },
                    title: isLoading ? "submitting" : 'Submit Store Info')),
          ],
        ),
      ),
    );
  }
}
