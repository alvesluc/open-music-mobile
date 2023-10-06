import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    this.initialValue,
    this.label,
    this.onChanged,
    this.keyboardType,
    this.validator,
  });

  final String? initialValue;
  final String? label;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        label: label != null ? Text(label!) : null,
      ),
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
