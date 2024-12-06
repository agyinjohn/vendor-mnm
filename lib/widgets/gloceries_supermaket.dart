import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class GroceriesUploadPage extends StatefulWidget {
  const GroceriesUploadPage({super.key});

  @override
  _GroceriesUploadPageState createState() => _GroceriesUploadPageState();
}

class _GroceriesUploadPageState extends State<GroceriesUploadPage> {
  final TextEditingController _manufacturedDateController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  String selectedCategory = 'Fresh Produce';
  final List<String> categories = [
    'Fresh Produce',
    'Beverages',
    'Snacks',
    'Dairy Products',
    'Packaged Foods',
    'Household Items',
  ];

  @override
  void dispose() {
    _manufacturedDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Widget _buildCommonFields() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
    );
  }

  Widget _buildCategorySpecificFields() {
    switch (selectedCategory) {
      case 'Fresh Produce':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type of Produce',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Apples, Spinach, Bananas',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Weight (e.g., 1kg, 500g)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
      case 'Beverages':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Beverage Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Juice, Soda, Coffee',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Volume (e.g., 1L, 500ml)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
      case 'Snacks':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Snack Type', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Chips, Biscuits, Popcorn',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      case 'Dairy Products':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dairy Product Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Milk, Cheese, Yogurt',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Volume/Weight (e.g., 1L, 500g)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
      case 'Packaged Foods':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Food Type',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Canned, Frozen, Dry',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            TextField(
              controller: _manufacturedDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Manufactured Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () =>
                      _selectDate(context, _manufacturedDateController),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _expiryDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Expiry Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _expiryDateController),
                ),
              ),
            ),
          ],
        );
      case 'Household Items':
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item Type', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g., Cleaning Supplies, Detergents, Paper Towels',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Volume/Weight (e.g., 1L, 500ml)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
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
        _buildCommonFields(),
        const SizedBox(height: 16),
        _buildCategorySpecificFields(),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // Handle form submission
          },
          child: const Text('Upload Product'),
        ),
      ],
    );
  }
}
