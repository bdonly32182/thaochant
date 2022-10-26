import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String invalidText;
  final String label;
  final int? maxline;
  final Color color;
  const TextFormFieldCustom(
      {Key? key,
      required this.color,
      required this.controller,
      required this.invalidText,
      required this.label,
      this.maxline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxline ?? 1,
      validator: (value) {
        if (value!.isEmpty) return invalidText;
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          )),
      style: TextStyle(color: color, fontWeight: FontWeight.w700),
    );
  }
}
