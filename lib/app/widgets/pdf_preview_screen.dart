/*
 *  Created by Yellow Strawberry LLP on 09/06/26, 6:21 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 09/06/26, 6:21 pm
 *
 */

// pdf_preview_screen.dart

import 'package:webview_flutter/webview_flutter.dart';
import '../packages.dart';
import 'common_app_bar.dart';

class PdfPreviewScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfPreviewScreen({super.key, required this.pdfUrl});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.pdfUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Document Preview"),

      body: WebViewWidget(controller: controller),
    );
  }
}
