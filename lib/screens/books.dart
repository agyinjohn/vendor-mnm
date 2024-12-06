import 'package:flutter/material.dart';

class BooksStationeryUploadPage extends StatefulWidget {
  const BooksStationeryUploadPage({super.key});

  @override
  _BooksStationeryUploadPageState createState() =>
      _BooksStationeryUploadPageState();
}

class _BooksStationeryUploadPageState extends State<BooksStationeryUploadPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();

  String selectedCategory = 'Books';
  String selectedSubCategory = 'Fiction';

  final List<String> categories = ['Books', 'Stationery'];
  final List<String> booksSubCategories = [
    'Fiction',
    'Non-fiction',
    'Educational',
    'Comics',
    'Magazines',
  ];

  final List<String> stationerySubCategories = [
    'Notebooks',
    'Pens',
    'Markers',
    'Art Supplies',
    'Office Supplies',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  Widget _buildCommonFields() {
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
    if (selectedCategory == 'Books') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _authorController,
            decoration: const InputDecoration(
              labelText: 'Author',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _publisherController,
            decoration: const InputDecoration(
              labelText: 'Publisher',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _isbnController,
            decoration: const InputDecoration(
              labelText: 'ISBN',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    } else if (selectedCategory == 'Stationery') {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Stationery Type',
              hintText: 'e.g., Pen, Notebook, Marker',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Books & Stationery Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
                  selectedSubCategory = selectedCategory == 'Books'
                      ? booksSubCategories.first
                      : stationerySubCategories.first;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text('Sub-Category',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedSubCategory,
              items: (selectedCategory == 'Books'
                      ? booksSubCategories
                      : stationerySubCategories)
                  .map((subCategory) {
                return DropdownMenuItem(
                  value: subCategory,
                  child: Text(subCategory),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubCategory = value!;
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
        ),
      ),
    );
  }
}
