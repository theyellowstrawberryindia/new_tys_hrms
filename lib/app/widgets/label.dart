/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:28 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:28 pm
 *
 */


// Project imports:
import 'package:hrms_ys/app/packages.dart';

class Label extends StatelessWidget {
  final String text;
  final int? maxLine;
  final TextStyle? style;
  final TextOverflow overflow;

  final TextAlign? align;


  const Label({
    super.key,
    required this.text,
    this.style,
    this.align,
    this.overflow = TextOverflow.visible,
    this.maxLine,

  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      maxLines: maxLine,
      style: style ?? AppTheme.textStyle(),
      textAlign: align,
      overflow: TextOverflow.ellipsis,
    );
  }
}
