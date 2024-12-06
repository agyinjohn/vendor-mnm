import 'package:flutter/material.dart';

class PharmacyUploadPage extends StatefulWidget {
  const PharmacyUploadPage({super.key});

  @override
  _PharmacyUploadPageState createState() => _PharmacyUploadPageState();
}

class _PharmacyUploadPageState extends State<PharmacyUploadPage> {
  final TextEditingController _diseaseController = TextEditingController();
  final List<Map<String, dynamic>> _drugs = [];
  final TextEditingController _drugNameController = TextEditingController();
  final TextEditingController _drugDescriptionController =
      TextEditingController();
  final TextEditingController _drugDosageController = TextEditingController();
  final TextEditingController _drugPriceController = TextEditingController();

  @override
  void dispose() {
    _diseaseController.dispose();
    _drugNameController.dispose();
    _drugDescriptionController.dispose();
    _drugDosageController.dispose();
    _drugPriceController.dispose();
    super.dispose();
  }

  void _addDrug() {
    setState(() {
      _drugs.add({
        'name': _drugNameController.text,
        'description': _drugDescriptionController.text,
        'dosage': _drugDosageController.text,
        'price': _drugPriceController.text,
      });
      _drugNameController.clear();
      _drugDescriptionController.clear();
      _drugDosageController.clear();
      _drugPriceController.clear();
    });
  }

  void _removeDrug(int index) {
    setState(() {
      _drugs.removeAt(index);
    });
  }

  Widget _buildDrugForm() {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextField(
          controller: _drugNameController,
          decoration: const InputDecoration(
            labelText: 'Drug Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _drugDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _drugDosageController,
          decoration: const InputDecoration(
            labelText: 'Dosage',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _drugPriceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Price',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addDrug,
          child: const Text('Add Drug'),
        ),
      ],
    );
  }

  Widget _buildDrugList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _drugs.length,
      itemBuilder: (context, index) {
        final drug = _drugs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: ListTile(
            title: Text(drug['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${drug['description']}'),
                Text('Dosage: ${drug['dosage']}'),
                Text(
                    'Price: GHC ${double.tryParse(drug['price'])?.toStringAsFixed(2)}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeDrug(index),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Pharmacy Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _diseaseController,
              decoration: const InputDecoration(
                labelText: 'Disease',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Drugs', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildDrugForm(),
            const SizedBox(height: 24),
            _buildDrugList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle form submission
              },
              child: const Text('Upload Disease and Drugs'),
            ),
          ],
        ),
      ),
    );
  }
}
