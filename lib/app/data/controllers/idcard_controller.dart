/*
 *  Created by Yellow Strawberry LLP on 22/06/26, 5:04 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 22/06/26, 5:04 pm
 *
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/utils.dart';
import '../../packages.dart';

class IDCardController extends GetxController {
  final ScreenshotController frontCardController = ScreenshotController();

  final ScreenshotController backCardController = ScreenshotController();

  Future<void> downloadIdCard() async {
    try {
      Loader.showLoader();

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      final Uint8List? frontImage =
      await frontCardController.capture(
        delay: const Duration(milliseconds: 100),
      );


      final Uint8List? backImage =
      await backCardController.capture(
        delay: const Duration(milliseconds: 100),
      );


      if (frontImage != null) {
        final result = await ImageGallerySaverPlus.saveImage(
          frontImage,
          name: "IDCard_Front",
        );

        AppUtils.printMessage(
          "FRONT SAVE => $result",
        );
      }


      if (backImage != null) {
        final result = await ImageGallerySaverPlus.saveImage(
          backImage,
          name: "IDCard_Back",
        );

        AppUtils.printMessage(
          "BACK SAVE => $result",
        );
      }


      Loader.hideLoader();

      Toast.success(
        message: "ID Card saved to gallery",
      );
    } catch (e) {
      Loader.hideLoader();

      AppUtils.printMessage(
        "DOWNLOAD ERROR => $e",
      );

      Toast.error(
        message: e.toString(),
      );
    }
  }

  Future<File?> _generatePdf() async {
    try {

      final frontImage =
      await frontCardController.capture(
        delay: const Duration(milliseconds: 300),
      );


      final backImage =
      await backCardController.capture(
        delay: const Duration(milliseconds: 300),
      );


      if (frontImage == null || backImage == null) {
        AppUtils.printMessage("PDF IMAGE NULL");
        return null;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(frontImage),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(backImage),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );


      final dir = await getTemporaryDirectory();

      final file = File(
        "${dir.path}/employee_id_card.pdf",
      );

      await file.writeAsBytes(
        await pdf.save(),
      );

      // AppUtils.printMessage("PDF FILE => ${file.path}");

      return file;
    } catch (e) {
      AppUtils.printMessage(
        "PDF ERROR => $e",
      );

      return null;
    }
  }

  Future<void> printIdCard() async {
    try {
      final file = await _generatePdf();

      if (file == null) {
        Toast.error(message: "Unable to generate PDF");
        return;
      }

      await Printing.layoutPdf(
        onLayout: (format) async {
          return await file.readAsBytes();
        },
      );
    } catch (e) {
      AppUtils.printMessage(
        "PRINT ERROR => $e",
      );
    }
  }
  Future<void> shareIdCard() async {
    try {
      final file = await _generatePdf();

      if (file == null) {
        Toast.error(message: "Unable to generate PDF");
        return;
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: "Employee ID Card",
        ),
      );
    } catch (e) {
      AppUtils.printMessage(
        "SHARE ERROR => $e",
      );
    }
  }

}
