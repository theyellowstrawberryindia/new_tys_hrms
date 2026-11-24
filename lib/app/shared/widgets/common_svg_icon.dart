/*
 *  Created by Yellow Strawberry LLP on 26/05/26, 1:08 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 26/05/26, 1:08 pm
 *
 */

import 'package:flutter_svg/flutter_svg.dart';
import '../packages.dart';

class CommonSvgIcon extends StatelessWidget {

  final String asset;
  final double size;
  final Color? color;

  const CommonSvgIcon({
    super.key,
    required this.asset,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {

    return SvgPicture.asset(
      asset,

      width: size,
      height: size,

      colorFilter: ColorFilter.mode(
        color ??
            Theme.of(context)
                .colorScheme
                .secondary,

        BlendMode.srcIn,
      ),
    );
  }
}