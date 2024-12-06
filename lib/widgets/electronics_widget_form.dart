// import 'package:flutter/material.dart';

// class ElectronicsFormWidget extends StatefulWidget {
//   final String selectedCategory;

//   const ElectronicsFormWidget({super.key, required this.selectedCategory});

//   @override
//   _ElectronicsFormWidgetState createState() => _ElectronicsFormWidgetState();
// }

// class _ElectronicsFormWidgetState extends State<ElectronicsFormWidget> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _modelController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _storageController = TextEditingController();
//   final TextEditingController _screenSizeController = TextEditingController();
//   final TextEditingController _processorController = TextEditingController();
//   final TextEditingController _ramController = TextEditingController();

//   @override
//   void dispose() {
//     _modelController.dispose();
//     _priceController.dispose();
//     _storageController.dispose();
//     _screenSizeController.dispose();
//     _processorController.dispose();
//     _ramController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Model Name Input
//           _buildTextField(
//               _modelController, "Model Name", "Enter the model name"),

//           // Price Input
//           _buildTextField(_priceController, "Price", "Enter the price",
//               isNumber: true),

//           // Category-specific fields
//           if (widget.selectedCategory == "Phones" ||
//               widget.selectedCategory == "Laptops" ||
//               widget.selectedCategory == "Tablets" ||
//               widget.selectedCategory == "Smartwatches") ...[
//             _buildTextField(_storageController, "Storage Capacity (GB)",
//                 "Enter storage capacity",
//                 isNumber: true),
//           ],
//           if (widget.selectedCategory == "Phones" ||
//               widget.selectedCategory == "Tablets" ||
//               widget.selectedCategory == "Smartwatches") ...[
//             _buildTextField(_screenSizeController, "Screen Size (inches)",
//                 "Enter screen size",
//                 isNumber: true),
//           ],
//           if (widget.selectedCategory == "Laptops") ...[
//             _buildTextField(
//                 _processorController, "Processor", "Enter processor type"),
//             _buildTextField(_ramController, "RAM (GB)", "Enter RAM",
//                 isNumber: true),
//           ],
//           if (widget.selectedCategory == "Cameras") ...[
//             _buildTextField(
//                 _screenSizeController, "Megapixels", "Enter camera resolution",
//                 isNumber: true),
//           ],
//           if (widget.selectedCategory == "Home Appliances") ...[
//             _buildTextField(_screenSizeController, "Energy Efficiency Rating",
//                 "Enter energy efficiency rating"),
//           ],

//           // Add Submit Button
//           Padding(
//             padding: const EdgeInsets.only(top: 20.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   // Form submission logic here
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content: Text(
//                             'Submitting ${widget.selectedCategory} details')),
//                   );
//                 }
//               },
//               child: Text("Submit ${widget.selectedCategory}"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Method to create TextFields
//   Widget _buildTextField(
//       TextEditingController controller, String label, String hint,
//       {bool isNumber = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           border: const OutlineInputBorder(),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $label';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class ElectronicsFormWidget extends StatefulWidget {
  final String selectedCategory;
  final Function(Map<String, dynamic>) onSubmit;

  const ElectronicsFormWidget({
    super.key,
    required this.selectedCategory,
    required this.onSubmit,
  });

  @override
  _ElectronicsFormWidgetState createState() => _ElectronicsFormWidgetState();
}

class _ElectronicsFormWidgetState extends State<ElectronicsFormWidget> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _storageController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _screenSizeController = TextEditingController();
  final TextEditingController _processorController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _megapixelsController = TextEditingController();
  final TextEditingController _energyEfficiencyController =
      TextEditingController();
  final TextEditingController _otherFeaturesController =
      TextEditingController();

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _storageController.dispose();
    _ramController.dispose();
    _screenSizeController.dispose();
    _processorController.dispose();
    _colorController.dispose();
    _megapixelsController.dispose();
    _energyEfficiencyController.dispose();
    _otherFeaturesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'category': widget.selectedCategory,
        'model': _modelController.text,
        'price': _priceController.text,
        'storage': _storageController.text,
        'ram': _ramController.text,
        'screenSize': _screenSizeController.text,
        'processor': _processorController.text,
        'color': _colorController.text,
        'megapixels': _megapixelsController.text,
        'energyEfficiency': _energyEfficiencyController.text,
        'otherFeatures': _otherFeaturesController.text,
      };
      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Model and price fields
          _buildTextField(_modelController, "Model", "Enter model name"),

          // Variant-specific fields for phones, laptops, tablets, etc.
          if (["Phones", "Laptops", "Tablets", "Smartwatches"]
              .contains(widget.selectedCategory)) ...[
            _buildTextField(
                _storageController, "Storage (GB)", "Enter storage capacity",
                isNumber: true),
          ],
          if (["Laptops", "Tablets"].contains(widget.selectedCategory)) ...[
            _buildTextField(_ramController, "RAM (GB)", "Enter RAM capacity",
                isNumber: true),
            _buildTextField(
                _processorController, "Processor", "Enter processor type"),
          ],
          if (["Phones", "Tablets", "Smartwatches"]
              .contains(widget.selectedCategory)) ...[
            _buildTextField(_screenSizeController, "Screen Size (inches)",
                "Enter screen size",
                isNumber: true),
          ],
          if (["Cameras"].contains(widget.selectedCategory)) ...[
            _buildTextField(
                _megapixelsController, "Megapixels", "Enter resolution (MP)",
                isNumber: true),
          ],
          if (["Home Appliances"].contains(widget.selectedCategory)) ...[
            _buildTextField(_energyEfficiencyController, "Energy Efficiency",
                "Enter energy efficiency rating"),
          ],
          // General property - color
          _buildTextField(_colorController, "Color", "Enter color"),

          // Other features like condition (New/Used)

          // Submit Button
        ],
      ),
    );
  }

  // Helper method to create text fields
  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
