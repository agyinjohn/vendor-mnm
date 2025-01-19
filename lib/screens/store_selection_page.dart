import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mnm_vendor/app_colors.dart';
import 'package:mnm_vendor/providers/toggle_shop_status.dart';
import 'package:mnm_vendor/screens/dashboard_fragments/verification_page.dart';
import 'package:mnm_vendor/screens/preview_image_screen.dart';
import 'package:mnm_vendor/utils/selected_store_notifier.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/store_notifier.dart';
import '../widgets/error_alert_dialogue.dart';

class StoreDetailsPage extends ConsumerStatefulWidget {
  const StoreDetailsPage({super.key});
  static const routeName = '/store-details-page';

  @override
  ConsumerState<StoreDetailsPage> createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends ConsumerState<StoreDetailsPage> {
  String _convertMinsToTime(int mins) {
    final hours = mins ~/ 60;
    final minutes = mins % 60;
    final period = hours >= 12 ? 'PM' : 'AM';
    final displayHours = hours > 12
        ? hours - 12
        : hours == 0
            ? 12
            : hours;
    return '${displayHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
  }

  Future<void> _showImagePicker(BuildContext context,
      Function(File) onImageSelected, String id, WidgetRef ref) async {
    final picker = ImagePicker();
    File? selectedImage;

    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  selectedImage = File(pickedFile.path);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewScreen(
                        imageFile: selectedImage!,
                        storeId: id,
                        ref: ref,
                      ),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Picture'),
              onTap: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  selectedImage = File(pickedFile.path);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewScreen(
                        imageFile: selectedImage!,
                        storeId: id,
                        ref: ref,
                      ),
                    ),
                  );
                  // Close the bottom sheet
                }
              },
            ),
          ],
        ),
      ),
    );

    if (selectedImage != null) {
      onImageSelected(selectedImage!);
    }
  }

  Future<void> _uploadImage(File image) async {
    try {
      // Add your backend API call to upload the image
      // Example:
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL'),
      //   headers: {'Authorization': 'Bearer YOUR_TOKEN'},
      //   body: {'file': await MultipartFile.fromFile(image.path)},
      // );
      // Handle response
    } catch (e) {
      // Handle errors
    }
  }

  late String usertoken;
  bool isLoading = false;
  getUserStore() async {
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences pref = await SharedPreferences.getInstance();

      final token = pref.getString('token');
      setState(() {
        usertoken = token!;
      });
      print("Store token");
      print(token);
      await ref
          .read(storeProvider.notifier)
          .fetchStores(token!, context)
          .then((_) {
        final stores = ref.read(storeProvider);
        print(stores);
        if (stores.isNotEmpty) {
          setState(() {
            isLoading = false;
          });
          // Load selected store or select the first one
          ref
              .read(selectedStoreProvider.notifier)
              .loadSelectedStore(stores)
              .then((_) {
            print(stores);
          });
        } else {
          showCustomSnackbar(
              context: context,
              message: 'Your Account is not complete',
              duration: const Duration(milliseconds: 20),
              action: SnackBarAction(
                  label: "Continue",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const KycVerificationScreen()));
                  }));
          // Handle no stores available
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const KycVerificationScreen()));
          });
        }
      });
      // setState(() {
      //   isLoading = false;
      // });
    } on ClientException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(context, () {
          getUserStore();
        }, 'Something went wrong while trying to fetch shop details, try again!');
      });

      // showCustomSnackbar(context: context, message: e.toString());
    } catch (e) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Navigator.pushReplacementNamed(context, '/no-stores');
      // });
      // showCustomSnackbar(context: context, message: e.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(context, () {
          getUserStore();
        }, 'Something went wrong while trying to fetch shop details, try again!');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getShopStatus();
  }

  getShopStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final storeId = pref.getString('selectedStoreId');
    await ref.read(storeStatusProvider.notifier).fetchStoreStatus(storeId!);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final theme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final selectedStore = ref.watch(selectedStoreProvider);

    if (selectedStore == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No store selected',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }
    final storeStatusAsync = ref.watch(storeStatusProvider);
    // print(selectedStore.images.entries.first);
    print(">>>>>>>>>>>>>>>>>>>>>>>>");
    // print(selectedStore.images.entries.first.value['url']);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Shop Image
              if (selectedStore.images.isNotEmpty)
                Stack(
                  children: [
                    // SizedBox(
                    //   height: 250,
                    //   width: double.infinity,
                    //   child: Image.network(
                    //     '${selectedStore.images.entries.first.value['url']}',
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    Positioned(
                      top: 35,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 35,
                      child: Row(
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                child: Icon(Icons.edit),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showImagePicker(context, (image) {
                                    // Preview the image or directly upload it
                                  }, selectedStore.id, ref);
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: Icon(Icons.add_a_photo_rounded),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                )
              else
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Text(
                          'No image available',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 10,
                        top: 35,
                        child: Row(
                          children: [
                            const Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white70,
                                  child: Icon(Icons.edit),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showImagePicker(context, (image) {
                                      // Preview the image or directly upload it
                                    }, selectedStore.id, ref);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white70,
                                    child: Icon(Icons.add_a_photo_rounded),
                                  ),
                                )
                              ],
                            )
                          ],
                        ))
                  ],
                ),

              // Store Name and Rating Card

              // Store Details and Map
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 120),
                        Text(
                          'Close/Open Shop',
                          style: theme.textTheme.titleMedium,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColors.cardColor,
                          ),
                          width: size.width,
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: selectedStore.isOpened
                                              ? Colors.green
                                              : AppColors.errorColor2,
                                          size: size.width * 0.03,
                                        ),
                                        SizedBox(width: size.width * 0.014),
                                        Text(
                                          selectedStore.isOpened
                                              ? 'Opened'
                                              : 'Closed',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      selectedStore.isOpened
                                          ? 'You can receive orders'
                                          : 'You can\'t receive orders',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: selectedStore.isOpened,
                                  onChanged: (value) async {
                                    await ref
                                        .read(storeStatusProvider.notifier)
                                        .toggleStoreStatus(selectedStore.id,
                                            value ? 'OPEN' : 'CLOSED');
                                    getUserStore();
                                  },
                                  activeColor: Colors.white,
                                  inactiveThumbColor: AppColors.errorColor2,
                                  inactiveTrackColor: Colors.black87,
                                  activeTrackColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Shop Location',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                  selectedStore.location.coordinates[1],
                                  selectedStore.location.coordinates[0]),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('storeLocation'),
                                position: LatLng(
                                  selectedStore.location.coordinates[1],
                                  selectedStore.location.coordinates[0],
                                ),
                              ),
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 200,
            left: 16,
            right: 16,
            child: Card(
              color: AppColors.cardColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            selectedStore.storeName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(selectedStore.storeAddress),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                            '${_convertMinsToTime(selectedStore.startTime)} - ${_convertMinsToTime(selectedStore.endTime)}'),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(selectedStore.storePhone),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      children: [],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${selectedStore.ratings.totalRatedValue.toDouble()}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                                '${selectedStore.ratings.totalPeopleRated.toString()} reviews')
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.category_outlined,
                              color: Colors.grey,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              selectedStore.type.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.7),
              child: const NutsActivityIndicator(),
            )
        ],
      ),
    );
  }
}
