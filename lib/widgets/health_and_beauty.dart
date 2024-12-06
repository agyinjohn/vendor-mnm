import 'package:flutter/material.dart';

class HealthBeautyUploadPage extends StatefulWidget {
  const HealthBeautyUploadPage({super.key});

  @override
  _HealthBeautyUploadPageState createState() => _HealthBeautyUploadPageState();
}

class _HealthBeautyUploadPageState extends State<HealthBeautyUploadPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String selectedCategory = 'Skincare';

  // Categories for Health & Beauty
  final List<String> categories = [
    'Skincare',
    'Haircare',
    'Makeup',
    'Personal Care',
    'Fitness Products',
    'Supplements',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildProductFields() {
    // Common fields for all Health & Beauty products
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _brandController,
          decoration: const InputDecoration(
            labelText: 'Brand',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Price',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Quantity Available',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySpecificFields() {
    switch (selectedCategory) {
      case 'Skincare':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Skin Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'Oily', child: Text('Oily')),
                DropdownMenuItem(value: 'Dry', child: Text('Dry')),
                DropdownMenuItem(
                    value: 'Combination', child: Text('Combination')),
                DropdownMenuItem(value: 'Sensitive', child: Text('Sensitive')),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
          ],
        );
      case 'Haircare':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hair Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'Straight', child: Text('Straight')),
                DropdownMenuItem(value: 'Curly', child: Text('Curly')),
                DropdownMenuItem(value: 'Wavy', child: Text('Wavy')),
                DropdownMenuItem(value: 'Coily', child: Text('Coily')),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
          ],
        );
      case 'Makeup':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shade', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Shade',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      case 'Personal Care':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Unisex', child: Text('Unisex')),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
          ],
        );
      case 'Fitness Products':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Type', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText:
                    'Enter Fitness Product Type (e.g., Dumbbells, Yoga Mat)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      case 'Supplements':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Supplement Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText:
                    'Enter Supplement Type (e.g., Protein, Multivitamins)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          items: categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value!;
            });
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),

        // Common fields for all products
        _buildProductFields(),
        const SizedBox(height: 16),

        // Category-specific fields
        _buildCategorySpecificFields(),

        const SizedBox(height: 24),

        // Upload Button
        ElevatedButton(
          onPressed: () {
            // Handle form submission here
          },
          child: const Text('Upload Product'),
        ),
      ],
    );
  }
}
