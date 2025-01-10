// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mnm_vendor/widgets/custom_button.dart';

// class BussinessInfo extends StatefulWidget {
//   const BussinessInfo({super.key, required this.onComplete});
//   static const routeName = '/business-info';
//   final VoidCallback onComplete;
//   @override
//   _BussinessInfoState createState() => _BussinessInfoState();
// }

// class _BussinessInfoState extends State<BussinessInfo> {
//   late GoogleMapController mapController;

//   // Initial position on the map (e.g., New York)
//   final LatLng _initialPosition = const LatLng(40.712776, -74.005974);

//   // To store the selected location
//   LatLng? _selectedLocation;

//   // List to hold the markers
//   Set<Marker> _markers = {};

//   // Controllers for the form fields
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _businessTypeController = TextEditingController();

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   // Function to handle long press to place a pin (marker)
//   void _onLongPress(LatLng position) {
//     setState(() {
//       _selectedLocation = position;
//       _markers = {
//         Marker(
//           markerId: MarkerId(position.toString()),
//           position: position,
//           infoWindow: InfoWindow(
//             title: 'Pinned Location',
//             snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       };
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Business Info'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Register your business',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Please fill in the details below to register your account with us.',
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             const SizedBox(height: 16),
//             // Business name field
//             TextField(
//               controller: _businessNameController,
//               decoration: const InputDecoration(
//                 filled: true,
//                 hintText: 'Business name',
//                 prefixIcon: Icon(Icons.business),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Business type dropdown
//             DropdownButtonFormField<String>(
//               items: ['Retail', 'Food', 'Services', 'Technology']
//                   .map((type) => DropdownMenuItem(
//                         value: type,
//                         child: Text(type),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 _businessTypeController.text = value!;
//               },
//               decoration: const InputDecoration(
//                 filled: true,
//                 hintText: 'Business type',
//                 prefixIcon: Icon(Icons.category),
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Business location
//             const Text(
//               'Business location',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             const Text('Tap on the map to search for precise location'),
//             const SizedBox(height: 8),
//             // Map section
//             SizedBox(
//               height: 300,
//               child: GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: CameraPosition(
//                   target: _initialPosition,
//                   zoom: 10.0,
//                 ),
//                 markers: _markers,
//                 onLongPress:
//                     _onLongPress, // Allow user to pin location on long press
//                 myLocationEnabled: true, // Enable 'My Location' button
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Submit button
//             SizedBox(
//                 width: double.infinity,
//                 child: CustomButton(
//                     onTap: () {
//                       if (_selectedLocation != null) {
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: const Text('Confirm Submission'),
//                               content: Text(
//                                 'Business Name: ${_businessNameController.text}\n'
//                                 'Business Type: ${_businessTypeController.text}\n'
//                                 'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
//                               ),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text('Cancel'),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     widget.onComplete();
//                                     // Here, you can submit the data to your backend
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text('Submit'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content:
//                                 Text('Please select a location on the map'),
//                           ),
//                         );
//                       }
//                     },
//                     title: 'Submit business Info')),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/models/categories_model.dart';
import 'package:mnm_vendor/screens/dashboard_fragments/verification_page.dart';
import 'package:mnm_vendor/screens/upload_id_page.dart';
import 'package:mnm_vendor/utils/add_store.dart';
import 'package:mnm_vendor/utils/providers/categories_state_provider.dart';
import 'package:mnm_vendor/utils/providers/user_provider.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BussinessInfo extends ConsumerStatefulWidget {
  const BussinessInfo({super.key, required this.onComplete});
  static const routeName = '/business-info';
  final VoidCallback onComplete;

  @override
  _BussinessInfoState createState() => _BussinessInfoState();
}

class _BussinessInfoState extends ConsumerState<BussinessInfo> {
  late GoogleMapController mapController;

  // To store the user's current location
  LatLng? _currentPosition;

  // To store the selected location
  LatLng? _selectedLocation;

  // List to hold the markers
  Set<Marker> _markers = {};

  // Controllers for the form fields
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _businessTypeController = TextEditingController();
  final TextEditingController _storePhoneController = TextEditingController();
  CategoryModel? _selectedCategory;
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
  File? _selectedImage;
  String? _base64Image;
  String? filename;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        filename = pickedFile.name;
        print(filename);
        _selectedImage = File(pickedFile.path);
        print(_selectedImage);
        _base64Image = base64Encode(_selectedImage!.readAsBytesSync());
        print('Base64 Encoded Image: $_base64Image'); // Log for testing
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _base64Image = null;
    });
  }

  TimeOfDay? _openingTime;
  TimeOfDay? _closingTime;

  void _selectTime(BuildContext context, bool isOpeningTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isOpeningTime) {
          _openingTime = pickedTime;
        } else {
          _closingTime = pickedTime;
        }
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return "Not set";
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
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
            const SizedBox(height: 16),
            TextField(
              controller: _storeAddressController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Address: e.g. Makola',
                prefixIcon: Icon(Icons.location_pin),
                border: OutlineInputBorder(),
              ),
            ),
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
              'Select Shop Opening and Closing Times',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Opening Time:',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                Text(_formatTimeOfDay(_openingTime),
                    style: const TextStyle(fontSize: 16)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onPressed: () => _selectTime(context, true),
                  child: const Text(
                    'Set Opening Time',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Closing Time:', style: TextStyle(fontSize: 16)),
                Text(_formatTimeOfDay(_closingTime),
                    style: const TextStyle(
                      fontSize: 16,
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onPressed: () => _selectTime(context, false),
                  child: const Text(
                    'Set Closing Time',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            // ElevatedButton(
            //   onPressed: () {
            //     if (_openingTime != null && _closingTime != null) {
            //       final opening = _formatTimeOfDay(_openingTime);
            //       final closing = _formatTimeOfDay(_closingTime);
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(
            //           content: Text(
            //               'Shop Hours: Opening at $opening, Closing at $closing'),
            //         ),
            //       );
            //     } else {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(
            //           content:
            //               Text('Please select both opening and closing times.'),
            //         ),
            //       );
            //     }
            //   },
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: const Size(double.infinity, 50),
            //   ),
            //   child: const Text('Confirm Times'),
            // ),
            const SizedBox(height: 16),
            const Text(
              'Business logo/Shop image',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 3),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo),
                        title: const Text('Pick from Gallery'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('Take a Picture'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[200],
                ),
                child: Stack(
                  children: [
                    if (_selectedImage == null)
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                              child: Icon(Icons.add_a_photo,
                                  size: 50, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('Shop Logo or Shop Picture'),
                        ],
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    if (_selectedImage != null)
                      Positioned(
                        top: 3,
                        right: 5,
                        child: IconButton(
                          color: Colors.red,
                          icon: const Icon(Icons.clear, color: Colors.red),
                          onPressed: _clearImage,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Business location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Long press on the map to select precise location'),
            const SizedBox(height: 8),
            // Map section
            SizedBox(
              height: 300,
              child: _currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition ??
                            const LatLng(40.712776,
                                -74.005974), // Default if location fails
                        zoom: 10.0,
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
                          _storeAddressController.text.isNotEmpty &&
                          _selectedCategory != null &&
                          _storePhoneController.text.isNotEmpty) {
                        print('triggered');
                        print("${_openingTime!.hour}:${_openingTime!.minute}");
                        print(_closingTime);
                        try {
                          setState(() {
                            isLoading = true;
                          });

                          print(isLoading);
                          await StoreService.addStore(
                              contxt: context,
                              images: [
                                {
                                  "data": "base64,$_base64Image",
                                  "fileName": "$filename"
                                }
                              ],
                              startTime:
                                  '${_openingTime!.hour}:${_openingTime!.minute}',
                              endTime:
                                  '${_closingTime!.hour}:${_closingTime!.minute}',
                              token: token!,
                              storeAddress: _storeAddressController.text,
                              storeName: _businessNameController.text,
                              latitude: _selectedLocation!.latitude,
                              // 6.756197672214557,
                              longitude: _selectedLocation!.longitude,
                              // -1.6797468136824893,
                              storePhone: _storePhoneController.text,
                              type: _selectedCategory!.id,
                              ref: ref);
                          // widget.onComplete();
                          // showCustomSnackbar(
                          //     context: context,
                          //     message: 'store successfully added');
                          // Navigator.pushReplacementNamed(
                          //     context, KycVerificationScreen.routeName);
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
                            content: Text('Please all feilds are required'),
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
