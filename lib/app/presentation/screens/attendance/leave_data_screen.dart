import 'package:hrms_ys/app/packages.dart';

import '../../../data/controllers/leave_data_controller.dart';
import '../../../data/models/leave_data.dart';
import '../../../widgets/common_app_bar.dart';

class LeaveDataPage extends GetView<LeaveDataController> {
  const LeaveDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: const CommonAppBar(title: 'Leave Data'),
      backgroundColor: isDark
          ? AppColor.kDarkPrimaryBGColor
          : AppColor.kLightPrimaryBGColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LeaveDataToolbar(),
              const SizedBox(height: 16),
              const Expanded(child: LeaveDataTable()),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaveDataToolbar extends GetView<LeaveDataController> {
  const LeaveDataToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final cardColor = isDark
        ? AppColor.kDarkCardColor
        : AppColor.kLightCardColor;
    final textColor = isDark
        ? AppColor.kDarkTextColor
        : AppColor.kLightTextColor;

    return Row(
      children: [
        Obx(() {
          if (controller.terms.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border.all(color: AppColor.kBorderColor),
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<LeaveTerm>(
                value: controller.selectedTerm.value,
                dropdownColor: cardColor,
                style: TextStyle(color: textColor, fontSize: 14),
                items: controller.terms
                    .map(
                      (t) => DropdownMenuItem(value: t, child: Text(t.label)),
                    )
                    .toList(),
                onChanged: controller.onTermChanged,
              ),
            ),
          );
        }),
        const SizedBox(width: 12),
        _FilterButton(onTap: controller.onFilterPressed),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              AppColor.kButtonLinearColor_1,
              AppColor.kButtonLinearColor_2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Text(
          'Filter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class LeaveDataTable extends GetView<LeaveDataController> {
  const LeaveDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.errorMessage.value != null) {
        return Center(
          child: Text(
            controller.errorMessage.value!,
            style: AppTheme.textStyle(color: AppColor.kErrorColor),
          ),
        );
      }

      if (controller.rows.isEmpty) {
        return Center(
          child: Text(
            '',
            style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
          ),
        );
      }

      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: controller.rows.length,
        separatorBuilder: (_, __) =>
            Divider(color: AppColor.kBorderColor, height: 1),
        itemBuilder: (context, index) {
          final row = controller.rows[index];
          final color = controller.getStatusColor(row.attStatus);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// STATUS ICON
                Icon(
                  _getIcon(row.attStatus),
                  color: controller.getStatusColor(row.attStatus),
                ),
                const SizedBox(width: 12),

                /// CONTENT
                Expanded(
                  child: Column(
                    children: [
                      /// DATE + DAY
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date",
                                  style: AppTheme.textStyle(
                                    size: 14,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  row.attDate ?? '-',
                                  style: AppTheme.textStyle(
                                    size: 10,
                                    color: AppColor.kGrayTextColor,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Day",
                                  style: AppTheme.textStyle(
                                    size: 14,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  row.attDay ?? '-',
                                  textAlign: TextAlign.end,
                                  style: AppTheme.textStyle(
                                    size: 10,
                                    color: AppColor.kGrayTextColor,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      /// IN TIME + OUT TIME
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "In Time",
                                  style: AppTheme.textStyle(
                                    size: 14,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  row.inTime ?? '-',
                                  style: AppTheme.textStyle(
                                    size: 10,
                                    color: AppColor.kCheckOutGreen_2,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Out Time",
                                  style: AppTheme.textStyle(
                                    size: 14,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  row.outTime ?? '-',
                                  textAlign: TextAlign.end,
                                  style: AppTheme.textStyle(
                                    size: 10,
                                    color: AppColor.kCheckOutRed_2,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      /// TOTAL HOURS + STATUS
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Hours",
                                  style: AppTheme.textStyle(
                                    size: 14,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  row.totalHours ?? '-',
                                  style: AppTheme.textStyle(
                                    size: 10,
                                    color: AppColor.kGrayTextColor,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Status",
                                style: AppTheme.textStyle(
                                  size: 14,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _statusChip(row.attStatus ?? '-', color),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: AppTheme.textStyle(
          size: 10,
          weight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  IconData _getIcon(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case "late":
        return Icons.access_time_rounded;

      case "absent":
        return Icons.close_rounded;

      case "leave":
        return Icons.event_busy_rounded;

      case "halfday":
        return Icons.timelapse_rounded;

      default:
        return Icons.circle;
    }
  }
}
