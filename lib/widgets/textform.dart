import 'package:flutter/material.dart';

Widget textform({required String name,
required TextEditingController controller,
FormFieldValidator<String>? validator, required TextInputType keyboardType, required String hintText, required String label,}){
  return Padding(padding: const EdgeInsets.only(right: 24)
    ,child: TextFormField(
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      labelText: name,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ), 
    ),));
}

class BuildTextFormField1 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;

  const BuildTextFormField1({
    required this.controller,
    required this.labelText,
    this.isMultiline = false, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 340,
        child: TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class BuildTextFormField2 extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isMultiline;

  const BuildTextFormField2(
      {super.key,
      required this.controller,
      required this.labelText,
      this.isMultiline = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 340,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

  // ignore: unused_element
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6A8E4E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF6A8E4E), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter ${label.toLowerCase()}';
        }
        return null;
      },
    );
  }