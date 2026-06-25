/*
 *  Created by Yellow Strawberry LLP on 22/05/26, 3:46 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 22/05/26, 3:46 pm
 *
 */

import 'package:hrms_ys/app/data/bindings/dashboard_binding.dart';
import 'package:hrms_ys/app/packages.dart';
import 'package:hrms_ys/app/presentation/screens/auth/auth_screen.dart';
import 'package:hrms_ys/app/presentation/screens/dashboard/dashboard_screen.dart';

import '../../../core/utils/app_storage.dart';
import '../../../data/bindings/auth_binding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (AppStorage.isLoggedIn()) {
        Get.offAll(() => const DashboardScreen(), binding: DashboardBinding(), transition: Transition.fadeIn);
      } else {
        Get.offAll(() => const AuthScreen(), binding: AuthBinding(), transition: Transition.fadeIn);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.5, end: 1.0),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Image.asset(
            AssetPath.logo,
            width: 320,
          ),
        ),
      ),
    );
  }
}
