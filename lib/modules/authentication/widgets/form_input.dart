import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final TextEditingController controller;
  final Icon? leadingIcon;
  final Text? hint;
  final bool? isPassword;

  const FormInput({
    super.key,
    required this.controller,
    this.leadingIcon,
    this.hint,
    this.isPassword,
  });

  @override
  Widget build(BuildContext context) {
    final validatePasswordCheck = isPassword != null && isPassword == true;
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      obscureText: validatePasswordCheck,
      enableSuggestions: !validatePasswordCheck,
      autocorrect: !validatePasswordCheck,
      decoration: InputDecoration(
        prefixIcon: leadingIcon,
        filled: true,
        hint: hint,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
    );
  }
}
