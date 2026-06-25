/*
 *  Created by Yellow Strawberry LLP on 01/06/26, 2:53 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 01/06/26, 2:53 pm
 *
 */

import '../../../data/controllers/attendance_controller.dart';
import '../../../packages.dart';

class AttendanceMonthHeader extends StatelessWidget {
  final AttendanceController controller;

  const AttendanceMonthHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   height: 64,
        //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //
        //     children: [
        //       Text(
        //         "Attendance",
        //         style: AppTheme.textStyle(size: 24, weight: FontWeight.w600),
        //       ),
        //
        //       Container(
        //         height: 32,
        //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        //
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(16),
        //
        //           border: Border.all(color: AppColor.kPrimaryColor),
        //         ),
        //
        //         child: DropdownButton<int>(
        //           value: controller.selectedYear,
        //
        //           underline: const SizedBox(),
        //
        //           items: List.generate(5, (index) {
        //             final year = DateTime.now().year - 2 + index;
        //
        //             return DropdownMenuItem(
        //               value: year,
        //
        //               child: Text(year.toString(), style: AppTheme.textStyle()),
        //             );
        //           }),
        //
        //           onChanged: (value) {
        //             if (value != null) {
        //               controller.changeYear(value);
        //             }
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        const SizedBox(height: 8),

        SizedBox(
          height: 32,
          child: ListView.builder(
            controller: controller.monthScrollController,
            scrollDirection: Axis.horizontal,

            itemCount: controller.months.length,

            itemBuilder: (context, index) {
              final isSelected = controller.selectedMonth == index + 1;

              return GestureDetector(
                onTap: () {
                  controller.changeMonth(index + 1);
                },

                child: Container(
                  margin: const EdgeInsets.only(right: 10),

                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.kPrimaryColor.withValues(alpha: 0.15)
                        : Theme.of(context).colorScheme.surface,

                    borderRadius: BorderRadius.circular(24),

                    border: Border.all(color: AppColor.kPrimaryColor),
                  ),

                  child: Center(
                    child: Text(
                      controller.months[index],

                      style: AppTheme.textStyle(weight: FontWeight.w600),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
