import 'package:flutter/material.dart';

class GiftPackagesUploadPage extends StatefulWidget {
  const GiftPackagesUploadPage({super.key});

  @override
  _GiftPackagesUploadPageState createState() => _GiftPackagesUploadPageState();
}

class _GiftPackagesUploadPageState extends State<GiftPackagesUploadPage> {
  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _packageDescriptionController =
      TextEditingController();
  final TextEditingController _packagePriceController = TextEditingController();

  // List of occasions
  final List<String> _categories = [
    'Valentine’s Day',
    'Birthday',
    'Mother’s Day',
    'Father’s Day',
    'Christmas',
    'Anniversaries',
    'Easter',
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
  ];

  // Selected categories
  List<String> _selectedCategories = [];

  @override
  void dispose() {
    _packageNameController.dispose();
    _packageDescriptionController.dispose();
    _packagePriceController.dispose();
    super.dispose();
  }

  // Function to show multi-select dialog
  void _showMultiSelectDialog() async {
    final List<String>? selectedCategories = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: "Select Gift Package Occasions",
          items: _categories,
          selectedItems: _selectedCategories,
        );
      },
    );

    if (selectedCategories != null) {
      setState(() {
        _selectedCategories = selectedCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Gift Package')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields for Package Name, Description, and Price
            TextField(
              controller: _packageNameController,
              decoration: const InputDecoration(labelText: 'Package Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _packageDescriptionController,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: 'Package Description'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _packagePriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Package Price'),
            ),
            const SizedBox(height: 16),

            // Multi-select for selecting occasions
            GestureDetector(
              onTap: _showMultiSelectDialog,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _selectedCategories.isEmpty
                      ? 'Select Gift Package Occasions'
                      : _selectedCategories.join(', '),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle upload logic
                  _uploadGiftPackage();
                },
                child: const Text('Upload Gift Package'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle the upload logic
  void _uploadGiftPackage() {
    // Access the data from the controllers and selected categories
    String packageName = _packageNameController.text;
    String packageDescription = _packageDescriptionController.text;
    String packagePrice = _packagePriceController.text;
    List<String> selectedOccasions = _selectedCategories;

    print('Package Name: $packageName');
    print('Package Description: $packageDescription');
    print('Package Price: $packagePrice');
    print('Selected Occasions: ${selectedOccasions.join(', ')}');

    // Implement the actual upload logic here
  }
}

// Multi-select dialog widget
class MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<String> selectedItems;

  const MultiSelectDialog({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<String> _tempSelectedItems = [];

  @override
  void initState() {
    _tempSelectedItems = List.from(widget.selectedItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((item) {
            return CheckboxListTile(
              value: _tempSelectedItems.contains(item),
              title: Text(item),
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked == true) {
                    _tempSelectedItems.add(item);
                  } else {
                    _tempSelectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_tempSelectedItems);
          },
        ),
      ],
    );
  }
}
