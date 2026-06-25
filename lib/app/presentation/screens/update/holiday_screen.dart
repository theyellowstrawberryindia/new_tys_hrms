/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 2:04 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 2:04 pm
 *
 */

import 'package:intl/intl.dart';

import '../../../data/controllers/update_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';
import '../../../widgets/common_svg_icon.dart';

/*
 *  Created by Yellow Strawberry LLP on 06/06/26, 2:04 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 06/06/26, 2:04 pm
 *
 */

import 'package:intl/intl.dart';

import '../../../data/controllers/update_controller.dart';
import '../../../packages.dart';
import '../../../widgets/common_svg_icon.dart';

class HolidayScreen extends GetView<UpdateController> {
  final bool showAppBar;


  const HolidayScreen({super.key,    this.showAppBar = false});

  @override
  Widget build(BuildContext context) {

    final body = GetBuilder<UpdateController>(
      builder: (controller) {
        return RefreshIndicator(
          onRefresh: controller.refreshUpdates,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.symmetric(horizontal: 16),

            itemCount: controller.holidayList.length,

            itemBuilder: (context, index) {
              final item = controller.holidayList[index];

              final date = DateTime.parse(item.holidayDate ?? "");

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 14),

                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColor.kBorderColor),
                  ),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    /// LEFT DATE SECTION
                    Container(
                      width: 95,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                size: 16,
                                color: AppColor.kPrimaryColor,
                              ),

                              const SizedBox(width: 4),

                              Expanded(
                                child: Text(
                                  DateFormat("MMM d, yyyy").format(date),

                                  style: AppTheme.textStyle(
                                    size: 10,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),

                          Text(
                            DateFormat("EEEE").format(date),

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

                    /// HOLIDAY NAME
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Holiday",

                            style: AppTheme.textStyle(
                              size: 10,
                              color: AppColor.kGrayTextColor,
                              weight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            item.holidayName ?? "",

                            style: AppTheme.textStyle(
                              size: 16,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// ICON
                    Container(
                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: AppColor.kPrimaryColor.withValues(alpha: 0.12),

                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: CommonSvgIcon(
                        asset: AssetPath.holidayIcon,

                        size: 24,

                        color: AppColor.kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
    if (!showAppBar) {
      return body;
    }

    return Scaffold(
      appBar: const CommonAppBar(
        title: "Holiday List",
      ),
      body: body,
    );
  }
}
