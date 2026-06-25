/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 3:12 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 3:12 pm
 *
 */

import 'dart:io';

import '../packages.dart';

Widget documentPreview({
  required String title,
  required String imageUrl,
  File? localFile,
  VoidCallback? onPdfTap,
  VoidCallback? onImageTap,
}) {
  final bool isPdfFile = imageUrl.toLowerCase().endsWith(".pdf");

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        child: Text(title, style: AppTheme.textStyle(weight: FontWeight.w600)),
      ),

      InkWell(
        onTap: () {
          if (imageUrl.isEmpty && localFile == null) {
            return;
          }

          if (isPdfFile) {
            onPdfTap?.call();
          } else {
            onImageTap?.call();
          }
        },

        child: Container(
          height: 180,

          margin: const EdgeInsets.symmetric(horizontal: 16),

          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Theme.of(Get.context!).colorScheme.surface
                : Colors.white,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(color: AppColor.kBorderColor),
          ),

          child: Builder(
            builder: (_) {
              /// LOCAL IMAGE
              if (localFile != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.file(
                    localFile,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }

              /// PDF
              if (isPdfFile) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      size: 70,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Tap to View PDF",
                      style: AppTheme.textStyle(weight: FontWeight.w600),
                    ),
                  ],
                );
              }

              /// IMAGE URL
              if (imageUrl.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }

              return Center(
                child: Text(
                  "No Document Available",
                  style: AppTheme.textStyle(color: AppColor.kGrayTextColor),
                ),
              );
            },
          ),
        ),
      ),

      const SizedBox(height: 16),
    ],
  );
}


class FullImagePreviewScreen extends StatelessWidget {
  final String imageUrl;

  const FullImagePreviewScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}