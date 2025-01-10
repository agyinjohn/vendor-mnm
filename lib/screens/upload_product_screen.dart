import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:mnm_vendor/models/categories_model.dart';
import 'package:mnm_vendor/screens/customized_ui_image_picker.dart';
import 'package:mnm_vendor/utils/fetch_stores.dart';
import 'package:mnm_vendor/utils/selected_store_notifier.dart';
import 'package:mnm_vendor/utils/upload_items_methods.dart';
import 'package:mnm_vendor/widgets/add_ons_widget.dart';
import 'package:mnm_vendor/widgets/gloceries_supermaket.dart';
import 'package:mnm_vendor/widgets/showsnackbar.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_colors.dart';
import '../utils/providers/categories_state_provider.dart';
import '../widgets/custom_button.dart';

class UploadProductScreen extends ConsumerStatefulWidget {
  const UploadProductScreen({super.key, this.selectedImages});
  final List<AssetEntity>? selectedImages;
  @override
  ConsumerState<UploadProductScreen> createState() =>
      _UploadProductScreenState();
}

class _UploadProductScreenState extends ConsumerState<UploadProductScreen> {
  List<String> imageList = [
    'assets/images/kelewele 1.png',
    'assets/images/kfc 2.png',
  ];

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController priceCategoryController = TextEditingController();
  TextEditingController dosageController = TextEditingController();

  bool isLoading = false;
  String dropdownValue = 'Size';

  bool hasPriceCategory = true;
  List<Map<String, dynamic>> priceList = [];
  String selectedSize = 'Small';
  String enteredPrice =
      '0.00'; // Variable to store the price for no price category

  final List<String> sizeOptions = ['Small', 'Medium', 'Large'];
  final FocusNode priceFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    // Listen to changes in the priceController and update the price
    priceController.addListener(() {
      setState(() {
        enteredPrice =
            double.tryParse(priceController.text)?.toStringAsFixed(2) ?? '0.00';
      });
    });
    _loadImages();
    // Get the store, not the notifier
    final selectedStoreNotifier = ref.read(
        selectedStoreProvider.notifier); // Get the notifier to call functions

    Future.microtask(() async {
      // Assume `stores` is fetched from somewhere else
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final token = pref.getString('token');
      final stores = await fetchStoresFromApi(token!, context);
      await selectedStoreNotifier.loadSelectedStore(stores);
    });
  }

  // TextEditingControllers for the add-on name and price fields
  final TextEditingController _add_ons_nameController = TextEditingController();
  final TextEditingController _add_ons_priceController =
      TextEditingController();
  final FocusNode _multiLineFocusNode = FocusNode();
  SubCategoryModel? _selectedSubCategory;
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  // List to store the add-ons (name and price)
  final List<Map<String, dynamic>> _addOns = [];

  // Function to add the add-on to the list
  void _addAddOn() {
    final name = _add_ons_nameController.text.trim();
    final price = _add_ons_priceController.text.trim();

    if (name.isNotEmpty && price.isNotEmpty) {
      setState(() {
        // Adding the add-on (name and price) to the list
        _addOns.add({'name': name, 'price': price});
      });

      // Clear the text fields for the next input
      _add_ons_nameController.clear();
      _add_ons_priceController.clear();
    }
  }

  void handleItemUpload(BuildContext context) async {
    final selectedStore =
        ref.watch(selectedStoreProvider); // Example if using Riverpod
    if (selectedStore != null) {
      final String storeId = selectedStore.id;
      final String storeType = selectedStore.type.name;
      List<Map<String, String>> base64Images = [];

      if (widget.selectedImages != null) {
        for (AssetEntity imageEntity in widget.selectedImages!) {
          final file = await imageEntity.file;
          if (file != null) {
            // Read the image file as bytes
            Uint8List bytes = await file.readAsBytes();

            // Convert the image to a base64 string
            String base64Image = base64Encode(bytes);

            // Extract the file name from the file path
            String fileName = file.path.split('/').last;

            // Store the file name and the base64 image string
            base64Images.add({
              'fileName': fileName,
              'data': 'base64,$base64Image',
            });
          }
        }
      }
      if (!hasPriceCategory) {
        priceList = [
          {
            'name': 'single',
            'price': priceCategoryController.text,
          }
        ];
      }
      Map<String, dynamic> itemData = {
        'name': productNameController.text,
        'description': productDescriptionController.text,
        'storeId': storeId,
        'enable': true,
        'categoryId': _selectedCategoryId,
        'subCategoryId': _selectedSubCategoryId,
        'images': base64Images,
        'sizes': priceList,
        'attributes': {"Add-ons": _addOns},
        'quantity': 1,

        // Add more fields based on your data model
      };
      try {
        setState(() {
          isLoading = true;
        });
        await uploadFastFoodItems(itemData, context);
      } catch (e) {
        print(e.toString());
        showCustomSnackbar(
            context: context, message: 'Failed to upload item ${e.toString()}');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print("No store selected.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No store selected')),
      );
    }
  }

  @override
  void dispose() {
    priceController.dispose();
    priceFocusNode.dispose();
    _multiLineFocusNode.dispose();
    _add_ons_nameController.dispose();
    _add_ons_priceController.dispose();
    super.dispose();
  }

  void addPriceEntry() {
    if (priceController.text.isEmpty) return;

    if (hasPriceCategory) {
      setState(() {
        priceList.add({
          'name': priceCategoryController.text,
          'price': double.tryParse(priceController.text)?.toStringAsFixed(2) ??
              '0.00',
        });
        priceController.clear();
        selectedSize = 'Small';
        priceFocusNode.unfocus();
      });
    } else {
      setState(() {
        final enteredPrice =
            double.tryParse(priceController.text)?.toStringAsFixed(2) ?? '0.00';

        priceController.clear();
        priceFocusNode.unfocus();

        // print("Entered price: $enteredPrice");
      });
    }
  }

  removeAddOnEntry(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this entry?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _addOns.removeAt(index); // Remove the entry
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void removePriceEntry(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this entry?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                // Close the dialog without deleting
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  priceList.removeAt(index); // Remove the entry
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  List<Future<Uint8List?>>? _imageFutures;

  void _loadImages() {
    _imageFutures =
        widget.selectedImages?.map((image) => image.originBytes).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final stores = ref.watch(storeProvider);
    // final selectedStore = ref.watch(selectedStoreProvider.notifier);
    // print(selectedStore);
    // Future.microtask(() async {
    //   await selectedStore.loadSelectedStore(stores);
    // });

    // Print the selected store details
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: size.width * 0.05),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                Icon(IconlyLight.arrow_left_2, size: 23),
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          ' ${selectedStore!.storeName}(${selectedStore.type.name}) ',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.width * 0.026,
              horizontal: size.height * 0.02,
            ),
            child: Column(
              children: [
                // Image upload section
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_imageFutures != null)
                        ..._imageFutures!.map((image) {
                          return FutureBuilder<Uint8List?>(
                            future: image, // Convert AssetEntity to Uint8List
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const NutsActivityIndicator(); // Show loader while loading
                              } else if (snapshot.hasError ||
                                  snapshot.data == null) {
                                return const Icon(Icons
                                    .error); // Show error icon if image fails to load
                              }

                              return Container(
                                height: size.height * 0.22,
                                width: size.height * 0.18,
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: MemoryImage(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      Container(
                        height: size.height * 0.22,
                        width: size.height * 0.18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 1),
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, MultipleImagePicker.routeName),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,
                                  size: size.width * 0.12,
                                  color: Colors.grey[700]),
                              const Text('Add Image(s)')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.03),
                // Product name section
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Product Name ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('*', style: TextStyle(color: AppColors.primaryColor)),
                  ],
                ),

                categoriesAsyncValue.when(
                  data: (types) {
                    // Step 1: Find the category based on the store name
                    final matchedCategory = types.firstWhere(
                      (category) =>
                          category.name ==
                          selectedStore.type
                              .name, // Compare the store name with category name
                      orElse: () => CategoryModel(
                        id: '',
                        name: '',
                        subCategories: [],
                        enabled: true,
                      ), // If no match is found, return null
                    );

                    if (matchedCategory == null) {
                      return const Text('No category found for this store');
                    }
                    _selectedCategoryId = matchedCategory.id;
                    return Column(
                      children: [
                        const SizedBox(height: 20),

                        // Step 2: Dropdown for Subcategories (only for the matched category)
                        if (matchedCategory.subCategories.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField<SubCategoryModel>(
                              hint: const Text('Select a subcategory'),
                              items: matchedCategory.subCategories
                                  .map<DropdownMenuItem<SubCategoryModel>>(
                                      (SubCategoryModel subCategory) =>
                                          DropdownMenuItem<SubCategoryModel>(
                                            value: subCategory,
                                            child: Text(
                                              subCategory.name,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ))
                                  .toList(),
                              onChanged: (selectedSubCategory) {
                                setState(() {
                                  _selectedSubCategory =
                                      selectedSubCategory; // Update the selected subcategory
                                  _selectedSubCategoryId =
                                      selectedSubCategory?.id;
                                });

                                if (_selectedSubCategory != null) {
                                  print(
                                      'Selected SubCategory ID: ${_selectedSubCategory!.id}');
                                }
                              },
                              value: _selectedSubCategory,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide.none),
                                filled: true,
                                hintText: 'Business subcategory',
                                prefixIcon: const Icon(
                                  Icons.subdirectory_arrow_right,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  error: (error, stack) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Error loading business types'),
                      IconButton(
                        onPressed: () {
                          setState(() {});
                        },
                        icon: const Icon(Icons.replay_outlined),
                      ),
                    ],
                  ),
                  loading: () => const NutsActivityIndicator(),
                ),

                SizedBox(height: size.height * 0.008),
                TextField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'Enter product name here ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                // Product description section

                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Product Description ',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('*', style: TextStyle(color: AppColors.primaryColor)),
                  ],
                ),
                SizedBox(height: size.height * 0.008),
                TextFormField(
                  focusNode: _multiLineFocusNode,
                  maxLines: 5,
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'Briefly describe your product here ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                if (selectedStore.type.name == 'fast food & beverages' ||
                    selectedStore.type.name == 'restaurants' ||
                    selectedStore.type.name == 'groceries & supermarkets') ...[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Does your product have a price category? ',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('*',
                          style: TextStyle(color: AppColors.primaryColor)),
                    ],
                  ),
                  SizedBox(height: size.height * 0.008),
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: hasPriceCategory,
                        onChanged: (bool? value) {
                          setState(() {
                            hasPriceCategory = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: false,
                        groupValue: hasPriceCategory,
                        onChanged: (bool? value) {
                          setState(() {
                            hasPriceCategory = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  if (hasPriceCategory) ...[
                    _buildHasPriceCategory(context),
                  ],
                  if (!hasPriceCategory) ...[
                    _buildHasNoPriceCategory(context),
                  ],
                ],

                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Attributes',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('*', style: TextStyle(color: AppColors.primaryColor)),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                if (selectedStore.type.name == 'pharmacy') ...[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    focusNode: _multiLineFocusNode,
                    controller: priceCategoryController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: _multiLineFocusNode,
                    maxLines: 5,
                    controller: dosageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: 'Briefly describe dosage/priscription here ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
                if (selectedStore.type.name == 'fast food & beverages' ||
                    selectedStore.type.name == 'restaurants') ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Add-ons',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        Text('*',
                            style: TextStyle(color: AppColors.primaryColor)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AddOnInput(
                      onPressed: _addAddOn,
                      nameController: _add_ons_nameController,
                      priceController: _add_ons_priceController,
                    ),
                  ),
                ],
                if (selectedStore.type.name == 'groceries & supermakets') ...[
                  const GroceriesUploadPage()
                ],
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _addOns.length,
                    itemBuilder: (context, index) {
                      final addOn = _addOns[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[300],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.022),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.26,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add-on',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                      Text(addOn['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                SizedBox(width: size.width * 0.024),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                    Text(
                                      'GHC ${double.tryParse(addOn['price'])?.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: size.width * 0.022),
                                  child: IconButton(
                                    icon: const Icon(IconlyBold.delete,
                                        size: 18, color: Colors.red),
                                    onPressed: () => removeAddOnEntry(index),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      // ListTile(
                      //   title: Text(addOn['name']),
                      //   subtitle: Text('Price: \$${addOn['price']}'),
                      // );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                SizedBox(height: size.width * 0.05),
                isLoading
                    ? const NutsActivityIndicator()
                    : CustomButton(
                        onTap: () {
                          if (selectedStore.type.name ==
                              'fast food & beverages') {
                            handleItemUpload(context);
                            print(priceList);
                          }
                        },
                        title: 'Upload Product'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHasPriceCategory(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: priceCategoryController,
                // Attach FocusNode
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Category name',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.022),
            Container(
              // width: size.width * 0.27,
              decoration: BoxDecoration(
                // color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'GHC:',
                style: TextStyle(fontSize: 8),
              ),
            ),
            SizedBox(width: size.width * 0.022),
            Expanded(
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Enter price',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.022),
            SizedBox(
              width: size.width * 0.15,
              child: CustomButton(
                onTap: addPriceEntry,
                title: 'Add',
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.012),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: priceList.length,
          itemBuilder: (context, index) {
            final entry = priceList[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.width * 0.016,
                horizontal: 0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                ),
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.022),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            Text(entry['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(width: size.width * 0.024),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            'GHC ${entry['price']}',
                            style: const TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: size.width * 0.022),
                        child: IconButton(
                          icon: const Icon(IconlyBold.delete,
                              size: 18, color: Colors.red),
                          onPressed: () => removePriceEntry(index),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHasNoPriceCategory(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Price', style: TextStyle(fontWeight: FontWeight.w700)),
            Text('*', style: TextStyle(color: AppColors.primaryColor)),
          ],
        ),
        SizedBox(height: size.height * 0.008),
        Row(
          children: [
            const Text(
              'GHC:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: size.width * 0.024),
            Expanded(
              child: TextField(
                controller: priceCategoryController,
                focusNode: priceFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Enter price',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.022),
          ],
        ),
        SizedBox(height: size.height * 0.012),
      ],
    );
  }
}
