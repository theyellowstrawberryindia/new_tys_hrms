

import 'package:hrms_ys/app/widgets/label.dart';

import '../packages.dart';

class CommonOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CommonOutlineButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: AppColor.kPrimaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: Label(
          text: text,
          style: AppTheme.textStyle(
            size: 22,
            weight: FontWeight.bold,
            color: AppColor.kPrimaryColor,
          ),
        ),
      ),
    );
  }
}