/*
 *  Created by Yellow Strawberry LLP on 23/05/26, 1:09 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 23/05/26, 1:09 pm
 *
 */


import 'package:hrms_ys/app/packages.dart';

class Loader {
  static bool _isLoading = false;

  static void showLoader() {
    if (_isLoading == false) {
      FocusManager.instance.primaryFocus?.unfocus();
      _isLoading = true;
      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(
            child: Stack(
              children: [
                Center(
                  child: Image.asset( Get.isDarkMode? AssetPath.darkModeLoaderIcon : AssetPath.loaderIcon,width: 40),
                ),
                Center(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(color: Get.isDarkMode? Colors.white : AppColor.kPrimaryColor,),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void hideLoader() {
    if (_isLoading) {
      _isLoading = false;
      Get.back();
    }
  }
}
