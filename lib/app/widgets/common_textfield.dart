/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:55 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:55 pm
 *
 */

import '../packages.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool isFocused;
  final FocusNode focusNode;
  final VoidCallback? onEyeTap;
  final bool isPasswordVisible;
  final String? Function(String?)? validator;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final VoidCallback? onSuffixTap;

  final VoidCallback? onPrefixTap;

  final bool readOnly;

  final VoidCallback? onTap;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.focusNode,
    required this.isFocused,
    this.isPassword = false,
    this.onEyeTap,
    this.isPasswordVisible = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onPrefixTap,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      focusNode: focusNode,

      validator: validator,

      autovalidateMode: AutovalidateMode.onUserInteraction,

      obscureText: isPassword ? !isPasswordVisible : false,

      style: AppTheme.textStyle(),

      cursorColor: AppColor.kPrimaryColor,

      readOnly: readOnly,

      onTap: onTap,

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: AppTheme.textStyle(color: Colors.grey),

        errorStyle: AppTheme.textStyle(color: Colors.red, size: 12),

        filled: true,

        fillColor: readOnly
            ? (Get.isDarkMode ? Colors.grey.shade800 : const Color(0xFFEDEDED))
            : (Get.isDarkMode ? const Color(0xFF2C2C2C) : Colors.white),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        prefixIcon: prefixIcon != null
            ? GestureDetector(onTap: onPrefixTap, child: prefixIcon)
            : null,

        suffixIcon: suffixIcon != null
            ? GestureDetector(onTap: onSuffixTap, child: suffixIcon)
            : isPassword
            ? GestureDetector(
                onTap: onEyeTap,
                child: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),

          borderSide: BorderSide(
            color: readOnly ? Colors.grey.shade300 : AppColor.kPrimaryColor,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),

          borderSide: BorderSide(
            color: isFocused ? Colors.orange : Colors.grey.shade300,

            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),

          borderSide: const BorderSide(color: Colors.red, width: 1.2),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),

          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
