/*
 *  Created by Yellow Strawberry LLP on 22/06/26, 4:04 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 22/06/26, 4:04 pm
 *
 */

import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../core/configs/app_configs.dart';
import '../../../core/utils/app_storage.dart';
import '../../../data/controllers/idcard_controller.dart';
import '../../../data/models/current_user.dart';
import '../../../packages.dart';
import '../../../widgets/common_app_bar.dart';

class IDCardScreen extends StatelessWidget {
  const IDCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUser = AppStorage.instance.getUserData();

    final employee = currentUser.data.first;

    final personal = currentUser.personalDetails.first;

    final familyDetail = currentUser.familyDetails.first;

    final professional = currentUser.professionalDetails.first;

    final imageUrl =
        "${AppConfig.imageBaseURL}storage/uploads/${personal.src ?? ""}";

    return GetBuilder<IDCardController>(
      builder: (controller) {
        return Scaffold(
          appBar: const CommonAppBar(title: "ID Card"),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                /// FRONT CARD
                Screenshot(
                  controller: controller.frontCardController,

                  child: _frontCard(
                    imageUrl: imageUrl,
                    employee: employee,
                    personal: personal,
                    professional: professional,
                  ),
                ),

                const SizedBox(height: 20),

                /// BACK CARD
                Screenshot(
                  controller: controller.backCardController,

                  child: _backCard(
                    employee: employee,
                    personal: personal,
                    familyDetail: familyDetail,
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            Get.context!,
                          ).colorScheme.surface,

                          foregroundColor: AppColor.kPrimaryColor,

                          elevation: 0,

                          side: BorderSide(color: AppColor.kBorderColor),
                        ),
                        onPressed: controller.downloadIdCard,

                        icon: const Icon(Icons.download),

                        label: Text(
                          "Download",
                          style: AppTheme.textStyle(
                            color: AppColor.kPrimaryColor,
                            size: 8,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            Get.context!,
                          ).colorScheme.surface,

                          foregroundColor: AppColor.kPrimaryColor,

                          elevation: 0,

                          side: BorderSide(color: AppColor.kBorderColor),
                        ),
                        onPressed: controller.printIdCard,

                        icon: const Icon(Icons.print),

                        label: Text(
                          "Print",
                          style: AppTheme.textStyle(
                            color: AppColor.kPrimaryColor,
                            size: 10,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            Get.context!,
                          ).colorScheme.surface,

                          foregroundColor: AppColor.kPrimaryColor,

                          elevation: 0,

                          side: BorderSide(color: AppColor.kBorderColor),
                        ),
                        onPressed: controller.shareIdCard,

                        icon: const Icon(Icons.share),

                        label: Text(
                          "Share",
                          style: AppTheme.textStyle(
                            color: AppColor.kPrimaryColor,
                            size: 10,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _frontCard({
    required String imageUrl,
    required dynamic employee,
    required dynamic personal,
    required dynamic professional,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.surface,

        borderRadius: BorderRadius.circular(28),

        border: Border.all(color: AppColor.kBorderColor),

        boxShadow: [
          BoxShadow(
            color: Get.isDarkMode
                ? Colors.black.withValues(alpha: 0.30)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          CircleAvatar(
            radius: 73,

            backgroundColor: AppColor.kPrimaryColor,

            child: CircleAvatar(
              radius: 71,

              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : const AssetImage(AssetPath.defaultProfile) as ImageProvider,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),

            decoration: BoxDecoration(
              color: AppColor.kPrimaryColor.withValues(alpha: 0.10),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Text(
              "${employee.firstName ?? ""} ${employee.lastName ?? ""}",
              style: AppTheme.textStyle(
                size: 24,
                weight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            professional.designation ?? "",
            style: AppTheme.textStyle(
              color: AppColor.kPrimaryColor,
              size: 16,
              weight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 40),

          _infoRow("Employee ID", "${employee.userid ?? ""}"),

          _infoRow("Joining Date", formatDob(professional.joiningDate ?? "")),

          _infoRow("Date of Birth", formatDob(personal.dob)),

          _infoRow("Gender", formatGender(personal.gender)),

          _infoRow("Phone Number", employee.phoneNumber),

          _infoRow("Email ID", employee.email ?? ""),

          //_infoRow("Website", "www.theyellowstrawberry.com"),
          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Image.asset(
              AssetPath.logo,
              height: 45,
            ),
          ),


          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _backCard({
    required dynamic employee,
    required dynamic personal,
    required dynamic familyDetail,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.surface,

        borderRadius: BorderRadius.circular(28),

        border: Border.all(color: AppColor.kBorderColor),

        boxShadow: [
          BoxShadow(
            color: Get.isDarkMode
                ? Colors.black.withValues(alpha: 0.30)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),

            child: Image.asset(
              AssetPath.logo,
              height: 80,
            ),
          ),

          const SizedBox(height: 30),

          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              "Website",
              style: AppTheme.textStyle(weight: FontWeight.w700, size: 12),
            ),
          ),

          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              "https://theyellowstrawberry.com/",
              style: AppTheme.textStyle(size: 12),
            ),
          ),

          const SizedBox(height: 30),

          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              "Emergency Contact",
              style: AppTheme.textStyle(weight: FontWeight.w700, size: 12),
            ),
          ),

          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              familyDetail.alternateContact,
              style: AppTheme.textStyle(size: 12),
            ),
          ),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              "Residential Address",
              style: AppTheme.textStyle(weight: FontWeight.w700, size: 12),
            ),
          ),

          const SizedBox(height: 6),

          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              "${personal.address ?? ""} ${personal.address2 ?? ""} ${personal.city ?? ""} ${personal.zipcode ?? ""} ${personal.state ?? ""} ${personal.country ?? ""}",
              style: AppTheme.textStyle(size: 12),
            ),
          ),

          const SizedBox(height: 30),

          Container(
            height: 220,
            width: 220,

            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),

            child: QrImageView(
              data: "https://theyellowstrawberry.com/",
              size: 220,

              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 130,

            child: Text(
              "$title :",
              style: AppTheme.textStyle(weight: FontWeight.w600, size: 12),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: AppTheme.textStyle(weight: FontWeight.w500, size: 12),
            ),
          ),
        ],
      ),
    );
  }

  String formatDob(dynamic dob) {
    if (dob == null || dob.toString().isEmpty) {
      return "-";
    }

    try {
      /// DateTime object
      if (dob is DateTime) {
        return DateFormat('d MMMM yyyy').format(dob);
      }

      final value = dob.toString();

      /// yyyy-MM-dd HH:mm:ss
      try {
        final date = DateTime.parse(value);
        return DateFormat('d MMMM yyyy').format(date);
      } catch (_) {}

      /// dd-MM-yyyy
      try {
        final date = DateFormat('dd-MM-yyyy').parse(value);
        return DateFormat('d MMMM yyyy').format(date);
      } catch (_) {}

      /// dd/MM/yyyy
      try {
        final date = DateFormat('dd/MM/yyyy').parse(value);
        return DateFormat('d MMMM yyyy').format(date);
      } catch (_) {}

      return value;
    } catch (_) {
      return dob.toString();
    }
  }

  String formatGender(String? gender) {
    switch (gender?.toUpperCase()) {
      case "ML":
        return "Male";

      case "FL":
        return "Female";

      case "OT":
        return "Other";

      default:
        return gender ?? "-";
    }
  }
}
