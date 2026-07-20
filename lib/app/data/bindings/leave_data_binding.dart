import 'package:hrms_ys/app/data/controllers/leave_data_controller.dart';
import 'package:hrms_ys/app/packages.dart';

class LeaveDataPageBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<LeaveDataController>()) {
      Get.lazyPut<LeaveDataController>(() => LeaveDataController());
    }
  }
}