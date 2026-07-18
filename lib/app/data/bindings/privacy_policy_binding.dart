import '../../packages.dart';
import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PolicyController>(() => PolicyController());
  }
}