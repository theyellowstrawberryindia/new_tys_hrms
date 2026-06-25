/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 1:18 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 1:18 pm
 *
 */

import '../packages.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonSocialIcon extends StatelessWidget {

  final String imagePath;
  final String url;
  final double size;

  const CommonSocialIcon({
    super.key,
    required this.imagePath,
    required this.url,
    this.size = 28,
  });

  /// OPEN URL
  Future<void> _openUrl() async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {

      debugPrint(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: _openUrl,
      child: Padding(
        padding: const EdgeInsets.all(4),

        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}