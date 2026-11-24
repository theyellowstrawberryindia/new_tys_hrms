import '../../../shared/packages.dart';

class HomeAttendanceCard extends StatelessWidget {
  const HomeAttendanceCard({super.key, required this.child});

  static const borderRadius = BorderRadius.all(Radius.circular(22));

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: borderRadius,
        border: Border.all(
          color: AppColor.kPrimaryColor.withValues(alpha: .18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColor.kPrimaryColor.withValues(alpha: .05),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
