import '../../../shared/packages.dart';

import '../../attendance/services/office_geofence.dart';
import 'home_attendance_card.dart';

class AttendanceLocationCard extends StatelessWidget {
  const AttendanceLocationCard({
    super.key,
    required this.message,
    required this.address,
    required this.status,
    this.isChecking = false,
    this.onOpenSettings,
  });

  final String message;
  final String address;
  final OfficeLocationStatus? status;
  final bool isChecking;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final needsSettings = onOpenSettings != null;
    final primaryIconColor = AppTheme.iconColor(context);
    final (icon, iconColor) = switch (status) {
      _ when needsSettings => (
        Icons.location_disabled_outlined,
        AppColor.kErrorColor,
      ),
      _ when isChecking => (Icons.my_location_rounded, primaryIconColor),
      OfficeLocationStatus.inside => (
        Icons.check_circle_outline_rounded,
        AppColor.kSuccessColor,
      ),
      OfficeLocationStatus.outside => (
        Icons.wrong_location_outlined,
        AppColor.kErrorColor,
      ),
      OfficeLocationStatus.uncertain => (
        Icons.location_searching_rounded,
        primaryIconColor,
      ),
      null => (Icons.location_on_outlined, primaryIconColor),
    };

    return SizedBox(
      width: double.infinity,
      child: HomeAttendanceCard(
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: .08),
                border: Border.all(color: iconColor.withValues(alpha: .15)),
              ),
              alignment: Alignment.center,
              child: isChecking && !needsSettings
                  ? SizedBox.square(
                      dimension: 20,
                      child: ExcludeSemantics(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: iconColor,
                        ),
                      ),
                    )
                  : Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 8),
            Semantics(
              liveRegion: true,
              child: Text(
                isChecking && !needsSettings
                    ? 'Verifying office location…'
                    : message,
                textAlign: TextAlign.center,
                style: AppTheme.textStyle(
                  context: context,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            if (!needsSettings && !isChecking && address.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                address,
                textAlign: TextAlign.center,
                style: AppTheme.textStyle(
                  context: context,
                  size: 12,
                  color: AppColor.kGrayTextColor,
                ),
              ),
            ],
            if (needsSettings) ...[
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onOpenSettings,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryIconColor,
                  side: const BorderSide(
                    color: AppColor.kPrimaryColor,
                    width: 1.5,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: AppTheme.textStyle(
                    context: context,
                    size: 12,
                    weight: FontWeight.w700,
                    color: primaryIconColor,
                  ),
                ),
                child: const Text(
                  'Open Location Settings',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
