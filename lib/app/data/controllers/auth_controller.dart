import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms_ys/app/core/core.dart';
import 'package:hrms_ys/app/data/bindings/dashboard_binding.dart';
import 'package:hrms_ys/app/presentation/screens/dashboard/dashboard_screen.dart';

import '../../core/utils/app_storage.dart';
import '../../packages.dart';
import '../repository/auth_repository.dart';

class AuthController extends GetxController {
  final authRepository = AuthRepository();

  final loginKey = GlobalKey<FormState>();

  /// CONTROLLERS
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// FOCUS NODES
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  /// PASSWORD VISIBILITY
  bool isPasswordVisible = false;

  /// FOCUS STATES
  bool isEmailFocused = false;
  bool isPasswordFocused = false;

  @override
  void onInit() {
    super.onInit();

    emailFocus.addListener(() {
      isEmailFocused = emailFocus.hasFocus;
      update();
    });

    passwordFocus.addListener(() {
      isPasswordFocused = passwordFocus.hasFocus;
      update();
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    ///Get Firebase Token
    FirebaseMessaging.instance.getToken().then((value) {
      AppStorage.instance.setValue(StorageKey.firebaseToken, value);
      AppUtils.printMessage("Firebase Token -- $value");
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocus.dispose();
    passwordFocus.dispose();

    super.onClose();
  }

  /// TOGGLE PASSWORD
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  /// EMAIL VALIDATION
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your Username/Work Email";
    }

    if (value.length > 50) {
      return "Maximum 50 characters allowed";
    }

    if (!GetUtils.isEmail(value.trim())) {
      return "Enter valid email address";
    }

    return null;
  }

  /// PASSWORD VALIDATION
  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your Password";
    }

    if (value.length < 7) {
      return "Password must contain at least 8 characters";
    }

    return null;
  }

  /// LOGIN
  void login() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!loginKey.currentState!.validate()) {
      return;
    }

    Loader.showLoader();

    Map<String, dynamic> body = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    authRepository
        .login(body)
        .then(
          (value) {
            Loader.hideLoader();
            AppUtils.printMessage("TOKEN - ${value['data']['token']}");

            if (value['status_code'] == 200) {

              AppStorage.setIsLoggedIn(true);
              AppStorage.setUserToken(value['data']['token']);
              Get.offAll(()=> const DashboardScreen(), binding: DashboardBinding(),);

            } else {
              Toast.error(message: value['errormsg']);
            }
          },

          onError: (e) {
            Loader.hideLoader();
            Toast.error(message: e);
          },
        );
  }
}
