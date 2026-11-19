import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });


@override
Widget build(BuildContext context) {
  final colors = Theme.of(context).colorScheme;

  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    keyboardType: keyboardType,

    style: TextStyle(
      color: colors.onSurface,
      fontSize: 14,
    ),

    decoration: InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        color: colors.onSurface.withOpacity(0.65),
        fontSize: 13,
      ),

      prefixIcon: Icon(
        icon,
        color: colors.secondary,
        size: 20,
      ),

      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colors.surface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.lightBorder
              : AppColors.darkBorder,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: colors.secondary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),
  );
}

}