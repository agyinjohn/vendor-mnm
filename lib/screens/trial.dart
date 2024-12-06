import 'package:flutter/material.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();

  // State for selected main category and subcategory
  String? _selectedCategory;
  String? _selectedSubcategory;

  List<Map<String, dynamic>> priceVariants = [];

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Main categories and their respective subcategories
  final Map<String, List<String>> _categorySubcategories = {
    'Electronics': [
      'Laptops',
      'Mobile Phones',
      'Cameras',
      'Tablets',
      'Home Appliances',
      'Computer Accessories',
      'HeadPhones',
      'Smartwatches'
    ],
    'Fashion & Apparel': [
      'Men',
      'Women',
      'Kids',
    ],
    'Restaurants': [
      'Fast Food',
    ],
    'Health & Beauthy': [
      'Skincare',
      'Haircare',
      'Makeup',
      'Personal Care',
      'Fitness Products',
      'Supplements'
    ],
    'Fast Food & Beverages': [
      'Fast Foods',
      'Beverages',
      'Snacks',
      'Bakery Items'
    ],
    'Books & Stationary': [
      'Books',
      'Stationary',
      'Fictions Books',
      'Non-fictions Books'
    ],
    'Gloceries & Supermarkets': [
      'Fresh Produce',
      'Beverages',
      'Snacks',
      'Diary Products',
      'Packaged Foods',
      'HouseHold Items(Cleaning, Detergents)'
    ],
    'Gift packages': [
      'Valentine’s Day',
      'Birthday',
      'Mother’s Day',
      'Father’s Day',
      'Christmas',
      'Anniversaries',
      ' Easter',
      'Weddings',
      'Graduations',
      'New Year',
      'Baby Showers',
      'Retirement',
      'Engagements',
      'Thanksgiving',
      'Hanukkah',
      'Ramadan & Eid',
      'Friendship Day',
      'Corporate Gifting',
      'Diwali',
    ],
    'Jewelry & Accessories': [
      'Watches',
      'Necklaces',
      'Earrings',
      'Rings',
      'Sunglasses',
      'Others'
    ],
    'Pet Supplies': [
      'Pet Food',
      'Pet Toys',
      'Grooming Supplies',
      'Pet Health Products',
    ],
    'Baby & Kids': [
      'Toys',
      'Baby Food',
      'Diapers and Baby Care Products',
      'Baby Clothes',
      'Others'
    ],
    'Pharmacy': ['Drugs', 'Supplements'],
    'Auto Parts': [
      'Engine Parts',
      'Transmission and Drivetrain',
      'Suspension and Steering',
      'Brakes',
      'Exhauts System',
      'Electrical and Lighting',
      'Cooling System',
      'Fuel System',
      'Interior Components',
      'Body and Exterior',
      'Air Conditioning and Heating',
      'Tires and Wheels'
    ]
  };

  // Dynamic fields based on subcategory selection
  List<Widget> _getDynamicFields(String subcategory) {
    List<Widget> dynamicFields = [];

    if (subcategory == 'Laptops') {
      dynamicFields.add(
        TextFormField(
          decoration: const InputDecoration(labelText: 'RAM Size'),
        ),
      );
      dynamicFields.add(
        TextFormField(
          decoration: const InputDecoration(labelText: 'Storage Capacity'),
        ),
      );
    } else if (subcategory == 'Mobile Phones') {
      dynamicFields.add(
        TextFormField(
          decoration: const InputDecoration(labelText: 'Screen Size'),
        ),
      );
      dynamicFields.add(
        TextFormField(
          decoration: const InputDecoration(labelText: 'Battery Capacity'),
        ),
      );
    } else if (subcategory == 'Men') {
      dynamicFields.add(
        TextFormField(
          decoration: const InputDecoration(labelText: 'Shirt Size'),
        ),
      );
      dynamicFields.add(
        TextFormField(
          decoration: const InputDecoration(labelText: 'Color'),
        ),
      );
    }
    // Add other subcategories with relevant fields.
    return dynamicFields;
  }

  // Add price variant fields dynamically
  Widget _priceVariantSection() {
    return Column(
      children: [
        for (int i = 0; i < priceVariants.length; i++)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Variant Name'),
                  initialValue: priceVariants[i]['name'],
                  onChanged: (value) => priceVariants[i]['name'] = value,
                ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Variant Price'),
                  initialValue: priceVariants[i]['price'].toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      priceVariants[i]['price'] = double.parse(value),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => setState(() => priceVariants.removeAt(i)),
              ),
            ],
          ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              priceVariants.add({'name': '', 'price': 0.0});
            });
          },
          child: const Text('Add Price Variant'),
        ),
      ],
    );
  }

  // Form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect all data and process it
      print('Item uploaded successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Title is required' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                      value!.isEmpty ? 'Description is required' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Price is required' : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Quantity is required' : null,
                ),
                // Dropdown for selecting main category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Select Category'),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _selectedSubcategory = null; // Reset subcategory
                    });
                  },
                  items: _categorySubcategories.keys.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'Category is required' : null,
                ),
                // Dropdown for selecting subcategory
                if (_selectedCategory != null)
                  DropdownButtonFormField<String>(
                    value: _selectedSubcategory,
                    hint: const Text('Select Subcategory'),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubcategory = value;
                      });
                    },
                    items: _categorySubcategories[_selectedCategory!]!
                        .map((subcategory) {
                      return DropdownMenuItem(
                        value: subcategory,
                        child: Text(subcategory),
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'Subcategory is required' : null,
                  ),
                // Dynamic fields based on subcategory
                if (_selectedSubcategory != null)
                  ..._getDynamicFields(_selectedSubcategory!),
                const SizedBox(height: 20),
                const Text('Price Variants',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _priceVariantSection(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
