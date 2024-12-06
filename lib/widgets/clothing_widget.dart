import 'package:flutter/material.dart';

class ClothingUploadPage extends StatefulWidget {
  final String category;

  const ClothingUploadPage({super.key, required this.category});

  @override
  _ClothingUploadPageState createState() => _ClothingUploadPageState();
}

class _ClothingUploadPageState extends State<ClothingUploadPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? selectedMaterial;
  List<String> selectedSizes = [];
  List<String> selectedColors = [];
  String? selectedShoeSize; // Only for Footwear
  String? selectedGender; // Only for Accessories

  final List<String> _availableSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'XXXL',
    'XXXXL'
  ];
  final List<String> _availableColors = ['Red', 'Blue', 'Black', 'White'];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Common Fields
          _buildTextField('Name', _nameController),
          _buildTextField('Brand', _brandController),
          _buildDropdownField('Material', ['Cotton', 'Polyester', 'Leather'],
              (val) => setState(() => selectedMaterial = val)),

          // Multi-Select for Sizes
          _buildMultiSelectField(
              'Sizes', selectedSizes, _availableSizes, _selectSizes),

          // Multi-Select for Colors
          _buildMultiSelectField(
              'Colors', selectedColors, _availableColors, _selectColors),

          _buildTextField('Stock Quantity', _stockController),

          // Specific Fields for Footwear
          if (widget.category.contains('Footwear')) ...[
            _buildDropdownField('Shoe Size', ['6', '7', '8', '9', '10'],
                (val) => setState(() => selectedShoeSize = val)),
          ],

          // Specific Fields for Accessories
          if (widget.category.contains('Accessories') ||
              widget.category.contains('Clothing')) ...[
            _buildDropdownField('Gender', ['Men', 'Women', 'Unisex', 'Kids'],
                (val) => setState(() => selectedGender = val)),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isOptional = false, bool isTextArea = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: isTextArea ? 5 : 1,
        decoration: InputDecoration(
          labelText: label,
          hintText: isOptional ? 'Optional' : null,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMultiSelectField(String label, List<String> selectedItems,
      List<String> availableItems, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: onPressed,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          child: Text(selectedItems.isNotEmpty
              ? selectedItems.join(', ')
              : 'Select $label'),
        ),
      ),
    );
  }

  void _selectSizes() async {
    final List<String>? results =
        await _showMultiSelectDialog(_availableSizes, selectedSizes);
    if (results != null) {
      setState(() {
        selectedSizes = results;
      });
    }
  }

  void _selectColors() async {
    final List<String>? results =
        await _showMultiSelectDialog(_availableColors, selectedColors);
    if (results != null) {
      setState(() {
        selectedColors = results;
      });
    }
  }

  Future<List<String>?> _showMultiSelectDialog(
      List<String> availableItems, List<String> selectedItems) {
    return showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          availableItems: availableItems,
          selectedItems: selectedItems,
        );
      },
    );
  }

  void _uploadProduct() {
    // Access form values and perform upload logic
    final name = _nameController.text;
    final brand = _brandController.text;
    final material = selectedMaterial;
    final sizes = selectedSizes;
    final colors = selectedColors;
    final price = _priceController.text;
    final stock = _stockController.text;
    final discountPrice = _discountController.text;
    final description = _descriptionController.text;

    print(
        'Product Uploaded: $name, $brand, $material, Sizes: $sizes, Colors: $colors, $price, $stock, $discountPrice, $description');
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> availableItems;
  final List<String> selectedItems;

  const MultiSelectDialog(
      {super.key, required this.availableItems, required this.selectedItems});

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelectedItems;

  @override
  void initState() {
    super.initState();
    _tempSelectedItems = List<String>.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select items'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.availableItems.map((item) {
            return CheckboxListTile(
              value: _tempSelectedItems.contains(item),
              title: Text(item),
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
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
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_tempSelectedItems);
          },
        ),
      ],
    );
  }
}
