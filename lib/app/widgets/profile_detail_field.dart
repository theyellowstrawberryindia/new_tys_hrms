import '../common/theme/app_color.dart';
import '../common/theme/app_theme.dart';
import '../packages.dart';
import 'common_textfield.dart';

class ProfileDetailField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isDateField;
  final int? minLength;
  final int? maxLength;

  final bool forceValidate;

  const ProfileDetailField({
    super.key,
    required this.title,
    required this.controller,
    required this.readOnly,
    this.onTap,
    this.isDateField = false,
    this.minLength,
    this.maxLength,
    this.forceValidate = false,
  });

  @override
  State<ProfileDetailField> createState() => _ProfileDetailFieldState();
}

class _ProfileDetailFieldState extends State<ProfileDetailField> {
  late final FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.controller.addListener(_onTextChanged);

    if (widget.forceValidate) {
      _validate(includeRequired: true);
    }
  }

  @override
  void didUpdateWidget(covariant ProfileDetailField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }

    if (widget.forceValidate && !oldWidget.forceValidate) {
      _validate(includeRequired: true);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _validate(includeRequired: widget.forceValidate);
  }

  void _validate({required bool includeRequired}) {
    if (widget.readOnly) {
      if (_errorText != null) setState(() => _errorText = null);
      return;
    }

    final text = widget.controller.text.trim();
    String? error;

    if (widget.isDateField) {
      if (text.isEmpty && includeRequired) {
        error = "${widget.title} is required";
      }
    } else {
      if (widget.minLength == null && widget.maxLength == null) return;

      if (text.isEmpty) {
        if (includeRequired) error = "${widget.title} is required";
      } else if (widget.minLength != null && text.length < widget.minLength!) {
        error = "${widget.title} must be at least ${widget.minLength} characters";
      } else if (widget.maxLength != null && text.length > widget.maxLength!) {
        error = "${widget.title} must be at most ${widget.maxLength} characters";
      }
    }

    if (error != _errorText) {
      setState(() => _errorText = error);
    }
  }
  /// Whether this field currently passes validation. Exposed so a
  /// parent could query it directly if ever needed.
  bool get isValid => _errorText == null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTheme.textStyle(size: 12, color: AppColor.kGrayTextColor),
          ),
          const SizedBox(height: 8),
          CommonTextField(
            controller: widget.controller,
            hintText: "",
            readOnly: widget.isDateField ? true : widget.readOnly,
            focusNode: _focusNode,
            isFocused: false,
            onTap: widget.onTap,
            styleReadOnly: widget.readOnly,
            maxLength: widget.maxLength,
            showCursor: widget.isDateField ? false : null,
            suffixIcon: widget.isDateField
                ? Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColor.kGrayTextColor,
            )
                : null,
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 4),
            Text(
              _errorText!,
              style: AppTheme.textStyle(size: 11, color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}