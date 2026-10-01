import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageTimestamp {
  /// Crop shape: height / width. 5 / 4 = 4:5 portrait (width:height).
  static const double cropAspect = 5 / 4;

  /// Crops the photo to the on-screen 3:4 guide, stamps
  /// date/time (24 hr) + short address, and saves it as a PNG.
  /// [guideSide] is the guide's WIDTH on screen.
  static Future<File> stamp(
      File file, {
        DateTime? time,
        String? address,
        Size? viewSize,
        double? guideSide,
      }) async {
    final bytes = await file.readAsBytes();
    log('Captured: ${(bytes.length / 1024).toStringAsFixed(0)} KB');

    // 1. Decode at native size
    final codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    log('Source pixels: ${image.width} x ${image.height}');

    // 2. Crop (3:4) = the guide, mapped from screen to photo pixels
    Rect srcRect;

    if (viewSize != null &&
        guideSide != null &&
        viewSize.width > 0 &&
        viewSize.height > 0) {
      // Cover-fit scale (how much the photo is enlarged on screen)
      final double s = math.max(
        viewSize.width / image.width,
        viewSize.height / image.height,
      );

      // Photo offset on screen (negative when it overflows)
      final double offX = (viewSize.width - image.width * s) / 2;
      final double offY = (viewSize.height - image.height * s) / 2;

      // Guide size on screen, centered
      final double guideW = guideSide;
      final double guideH = guideSide * cropAspect;

      final double gLeft = (viewSize.width - guideW) / 2;
      final double gTop = (viewSize.height - guideH) / 2;

      // Width/height in photo pixels, never larger than the photo
      final double cw = math.min(guideW / s, image.width.toDouble());
      final double ch = math.min(guideH / s, image.height.toDouble());

      // Top-left in photo pixels, kept inside the photo
      final double left = ((gLeft - offX) / s).clamp(0.0, image.width - cw);
      final double top = ((gTop - offY) / s).clamp(0.0, image.height - ch);

      srcRect = Rect.fromLTWH(left, top, cw, ch);
    } else {
      // Fallback: centered 3:4 crop
      final double cw =
      math.min(image.width.toDouble(), image.height / cropAspect);
      final double ch = cw * cropAspect;
      srcRect = Rect.fromLTWH(
        (image.width - cw) / 2,
        (image.height - ch) / 2,
        cw,
        ch,
      );
    }

    final int cropW = srcRect.width.round();
    final int cropH = srcRect.height.round();
    final double w = cropW.toDouble();
    final double h = cropH.toDouble();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImageRect(
      image,
      srcRect,
      Rect.fromLTWH(0, 0, w, h),
      Paint()..filterQuality = FilterQuality.medium,
    );

    // 3. Text sizes (scale with the cropped width)
    final double fontSize = w * 0.055;
    final double addressFontSize = fontSize * 0.65;
    final double padH = fontSize * 0.8;
    final double padV = fontSize * 0.5;
    final double margin = w * 0.03;
    final double maxTextWidth = w - (margin * 2) - (padH * 2);

    // 24 hr date + time
    final dateText =
    DateFormat('dd MMM yyyy   HH:mm:ss').format(time ?? DateTime.now());

    final datePainter = TextPainter(
      text: TextSpan(
        text: dateText,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout(maxWidth: maxTextWidth);

    // Address (optional, small font, max 2 lines)
    final addressText = _cleanAddress(address);
    TextPainter? addressPainter;

    if (addressText.isNotEmpty) {
      addressPainter = TextPainter(
        text: TextSpan(
          text: addressText,
          style: TextStyle(
            color: Colors.white,
            fontSize: addressFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        maxLines: 2,
        ellipsis: '…',
        textDirection: ui.TextDirection.ltr,
      )..layout(maxWidth: maxTextWidth);
    }

    // Black box, bottom-left
    final double gap = addressPainter != null ? fontSize * 0.25 : 0;
    final double contentW =
    math.max(datePainter.width, addressPainter?.width ?? 0);
    final double contentH =
        datePainter.height + gap + (addressPainter?.height ?? 0);

    final rect = Rect.fromLTWH(
      margin,
      h - margin - contentH - padV * 2,
      contentW + padH * 2,
      contentH + padV * 2,
    );

    canvas.drawRect(rect, Paint()..color = Colors.black);

    datePainter.paint(canvas, Offset(rect.left + padH, rect.top + padV));

    addressPainter?.paint(
      canvas,
      Offset(rect.left + padH, rect.top + padV + datePainter.height + gap),
    );

    // 4. Export as PNG (dart:ui)
    final picture = recorder.endRecording();
    final stamped = await picture.toImage(cropW, cropH);
    final data = await stamped.toByteData(format: ui.ImageByteFormat.png);

    final outFile = File(
      '${file.parent.path}/attendance_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await outFile.writeAsBytes(data!.buffer.asUint8List(), flush: true);

    final kb = (await outFile.length()) / 1024;
    log('Stamped PNG: ${kb.toStringAsFixed(0)} KB ($cropW x $cropH)');

    // 5. Cleanup
    image.dispose();
    stamped.dispose();
    picture.dispose();

    try {
      await file.delete();
    } catch (_) {}

    return outFile;
  }

  /// "g-square business park 1901, Vashi, Navi Mumbai, Maharashtra"
  ///   -> "g-square business park 1901, Vashi"
  static String _cleanAddress(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';

    final lowerRaw = raw.trim().toLowerCase();
    if (lowerRaw == 'unknown location' || lowerRaw == 'location unavailable') {
      return '';
    }

    var parts = raw
        .split(',')
        .map((e) => e.replaceAll(RegExp(r'\b\d{6}\b'), '').trim()) // pincode
        .where((e) =>
    e.isNotEmpty &&
        e.toLowerCase() != 'null' &&
        e.toLowerCase() != 'india')
        .toList();

    if (parts.length > 2) {
      parts = parts.sublist(0, parts.length - 2); // drop city + state
    }

    return parts.join(', ');
  }
}