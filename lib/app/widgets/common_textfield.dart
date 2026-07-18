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

  final int? maxLength;

  final bool isDateField;

  final bool? showCursor;

  final bool? styleReadOnly;

  final bool isEmail; // <-- new

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
    this.maxLength,
    this.isDateField = false,
    this.showCursor = true,
    this.styleReadOnly,
    this.isEmail = false, // <-- new
  });

  @override
  Widget build(BuildContext context) {
    final bool isStyleReadOnly = styleReadOnly ?? readOnly;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      textCapitalization:
      isEmail ? TextCapitalization.none : TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isPassword ? !isPasswordVisible : false,
      style: AppTheme.textStyle(),
      cursorColor: AppColor.kPrimaryColor,
      readOnly: readOnly,
      onTap: onTap,
      maxLength: maxLength,
      showCursor: isDateField ? false : showCursor,
      inputFormatters: isEmail || isPassword
          ? null
          : [_CapitalizeFirstLetterFormatter()],

      decoration: InputDecoration(
        hintText: hintText,
        counterText: "",
        hintStyle: AppTheme.textStyle(color: Colors.grey),
        errorStyle: AppTheme.textStyle(color: Colors.red, size: 12),

        filled: true,
        fillColor: isStyleReadOnly
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
            color: isStyleReadOnly ? Colors.grey.shade300 : AppColor.kPrimaryColor,
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

class _CapitalizeFirstLetterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) return newValue;

    final capitalized =
        newValue.text[0].toUpperCase() + newValue.text.substring(1);

    if (capitalized == newValue.text) return newValue;

    return newValue.copyWith(
      text: capitalized,
      selection: newValue.selection,
    );
  }
}