

import '../../packages.dart';
import '../controllers/education_controller.dart';

class EducationDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EducationDetailsController>(
          () => EducationDetailsController(),
      fenix: true,
    );
  }
}