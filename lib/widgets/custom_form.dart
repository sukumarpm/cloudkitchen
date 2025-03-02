import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height;
  final Function(String) onSaved;
  final String regEx;
  final bool obscureText;
  TextInputType keytype;

  CustomFormField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.onSaved,
      required this.regEx,
      required this.keytype,
      required this.height,
      required initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved(value!),
      cursorColor: Colors.green,
      initialValue: null,
      style: const TextStyle(color: Colors.black),
      obscureText: obscureText,
      keyboardType: keytype,
      validator: (value) {
        return RegExp(regEx).hasMatch(value!) ? null : 'Enter a valid value.';
      },
      decoration: InputDecoration(
        fillColor: const Color(0xffE3EBF2),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 12),
      ),
    );
  }
}
