import 'package:flutter/material.dart';
import 'package:mnm_vendor/widgets/custom_button.dart';

class AddOnInput extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController priceController;
  final VoidCallback onPressed;
  const AddOnInput(
      {super.key,
      required this.nameController,
      required this.priceController,
      required this.onPressed});

  @override
  State<AddOnInput> createState() => _AddOnInputState();
}

class _AddOnInputState extends State<AddOnInput> {
  // TextEditingControllers for the add-on name and price fields

  // Function to handle adding an add-on

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        // Name input field
        Expanded(
          flex: 2,
          child: TextField(
            controller: widget.nameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              hintText: 'e.g:salad',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Price input field
        Expanded(
          child: TextField(
            controller: widget.priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              hintText: 'Price',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Add button
        SizedBox(
          width: size.width * 0.20,
          child: CustomButton(
            onTap: widget.onPressed,
            title: 'Add',
          ),
        ),
      ],
    );
  }
}
