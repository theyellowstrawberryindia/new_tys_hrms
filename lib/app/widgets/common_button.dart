/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:56 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:56 pm
 *
 */

import 'package:hrms_ys/app/widgets/label.dart';

import '../packages.dart';


class CommonButton extends StatelessWidget {

  final String text;
  final VoidCallback onTap;

  const CommonButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          backgroundColor:AppColor.kPrimaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(35),
          ),
        ),

        child: Label(text: text,
          style: AppTheme.textStyle(
            size: 22,
            weight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}