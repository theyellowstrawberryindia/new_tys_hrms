/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:37 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:37 pm
 *
 */
import 'package:hrms_ys/app/core/utils/app_storage.dart';
import 'package:hrms_ys/app/data/bindings/auth_binding.dart';
import 'package:hrms_ys/app/data/repository/profile_repository.dart';
import 'package:hrms_ys/app/presentation/screens/attendance/apply_leave_screen.dart';
import 'package:hrms_ys/app/presentation/screens/auth/auth_screen.dart';
import 'package:hrms_ys/app/presentation/screens/update/holiday_screen.dart';
import 'package:hrms_ys/app/presentation/screens/update/notification_screen.dart';
import 'package:intl/intl.dart';

import '../../packages.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../core/configs/app_configs.dart';
import '../../presentation/screens/profile/bank_screen.dart';
import '../../presentation/screens/profile/contact_screen.dart';
import '../../presentation/screens/profile/family_screen.dart';
import '../../presentation/screens/profile/idcard_screen.dart';
import '../../presentation/screens/profile/personal_screen.dart';
import '../../presentation/screens/profile/professional_screen.dart';
import '../../widgets/common_confirmation_dialog.dart';
import '../../widgets/common_image_preview.dart';
import '../../widgets/pdf_preview_screen.dart';
import '../bindings/apple_leave_binding.dart';
import '../bindings/idcard_binding.dart';
import '../models/current_user.dart';

class ProfileController extends GetxController {
  final profileRepository = ProfileRepository();

  bool isNotificationEnabled = true;

  bool isDarkMode = Get.isDarkMode;

  CurrentUser? currentUser;

  File? selectedProfileImage;

  String profileImageUrl = "";

  String userName = "Jack Brown";

  String designation = "UI/UX Intern";

  bool isContactEditing = false;

  bool isProfessionalEditing = false;

  bool isPersonalEditing = false;

  bool isBankEditing = false;

  bool isFamilyEditing = false;

  final contactEmailController = TextEditingController();
  final contactPhoneController = TextEditingController();

  final designationController = TextEditingController();
  final experienceController = TextEditingController();
  final skillsController = TextEditingController();
  final joiningDateController = TextEditingController();
  final tysExperienceController = TextEditingController();

  final dobController = TextEditingController();
  final genderController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final personalEmailController = TextEditingController();
  final addressController = TextEditingController();

  final accountHolderController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final branchController = TextEditingController();
  final panController = TextEditingController();
  final aadharController = TextEditingController();
  String panCardImageUrl = "";
  String aadharCardImageUrl = "";
  File? panCardImageFile;
  File? aadharCardImageFile;

  final fatherNameController = TextEditingController();
  final motherNameController = TextEditingController();
  final alternateContactController = TextEditingController();
  final familyAddressController = TextEditingController();

  bool _loaded = false;

  void toggleNotification() {
    isNotificationEnabled = !isNotificationEnabled;

    update();
  }

  void toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);

    isDarkMode = Get.isDarkMode;

    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }


  Future<void> loadData() async {
    if (_loaded) return;
    _loaded = true;
    loadCurrentUser();
  }


  void loadCurrentUser() {
    currentUser = AppStorage.instance.getUserData();

    if (currentUser == null) {
      return;
    }

    if (currentUser!.data.isEmpty) {
      return;
    }

    final user = currentUser!.data.first;

    userName = "${user.firstName} ${user.lastName}";

    designation = currentUser?.professionalDetails.first.designation ?? "";

    /// Local image first
    profileImageUrl =
        "${AppConfig.imageBaseURL}storage/uploads/${currentUser?.personalDetails.first.src ?? ""}";

    /// API image fallback
    if (profileImageUrl.isEmpty) {
      final src = currentUser?.personalDetails.first.src ?? "";

      if (src.isNotEmpty) {
        profileImageUrl = "${AppConfig.imageBaseURL}storage/uploads/$src";
      }
    }

    final personal = currentUser!.personalDetails.isNotEmpty
        ? currentUser!.personalDetails.first
        : null;

    final professional = currentUser!.professionalDetails.isNotEmpty
        ? currentUser!.professionalDetails.first
        : null;

    final bank = currentUser!.bankDetails.isNotEmpty
        ? currentUser!.bankDetails.first
        : null;

    final family = currentUser!.familyDetails.isNotEmpty
        ? currentUser!.familyDetails.first
        : null;

    /// CONTACT

    contactEmailController.text = user.email;

    contactPhoneController.text = user.phoneNumber;

    /// PROFESSIONAL

    designationController.text = professional?.designation ?? "";

    experienceController.text = professional?.experience ?? "";

    skillsController.text = professional?.skills ?? "";

    if (professional?.joiningDate != null) {
      joiningDateController.text =
          DateFormat('dd MMM yyyy').format(professional!.joiningDate!);
    } else {
      joiningDateController.clear();
    }

    tysExperienceController.text = professional?.prevExperience ?? "";

    /// PERSONAL

    final dob = personal?.dob;

    if (dob != null) {
      dobController.text = DateFormat('dd MMM yyyy').format(dob);
    } else {
      dobController.clear();
    }

    genderController.text = personal?.gender ?? "";

    bloodGroupController.text = "NA";

    personalEmailController.text = "NA";

    addressController.text =
        "${personal?.address} ${personal?.address2} ${personal?.city} ${personal?.state}";

    /// BANK

    accountHolderController.text = bank?.nameAsBank ?? "";

    bankNameController.text = bank?.bankName ?? "";

    accountNumberController.text = bank?.accountNo ?? "";

    ifscController.text = bank?.ifscCode ?? "";

    branchController.text = bank?.branchName ?? "";

    panController.text = bank?.panCard ?? "";

    aadharController.text = bank?.aadharCard ?? "";

    if ((bank?.panImg ?? "").isNotEmpty) {
      panCardImageUrl = "${AppConfig.imageBaseURL}storage/${bank!.panImg}";
    }

    if ((bank?.aadharImg ?? "").isNotEmpty) {
      aadharCardImageUrl =
          "${AppConfig.imageBaseURL}storage/${bank?.aadharImg}";
    }

    /// FAMILY

    fatherNameController.text = family?.fatherName ?? "";

    motherNameController.text = family?.motherName ?? "";

    alternateContactController.text = family?.alternateContact ?? "";

    familyAddressController.text = family?.familyAddress ?? "";

    update();
  }

  void changeProfilePhoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.surface,

          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),

        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),

              title: Text("Camera", style: AppTheme.textStyle()),

              onTap: () {
                Get.back();

                pickProfileImage(ImageSource.camera);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo),

              title: Text("Gallery", style: AppTheme.textStyle()),

              onTap: () {
                Get.back();

                pickProfileImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 90,
    );

    if (image == null) return;

    final CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: image.path,

      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Picture',

          lockAspectRatio: true,

          hideBottomControls: false,
        ),

        IOSUiSettings(title: 'Crop Profile Picture'),
      ],
    );

    if (cropped == null) return;

    selectedProfileImage = File(cropped.path);

    await uploadProfilePicture();
  }

  Future<void> uploadProfilePicture() async {
    if (selectedProfileImage == null) {
      return;
    }

    Loader.showLoader();

    Map<String, String> body = {
      "userid": "${currentUser?.data.first.userid ?? ''}",
      "_method": "PUT",
    };

    profileRepository
        .changeProfilePhoto(body, selectedProfileImage)
        .then(
          (value) {
            Loader.hideLoader();

            if (value['success'] == true) {
              final imageUrl = value['data']['src'] ?? "";

              if (imageUrl.isNotEmpty) {
                profileImageUrl =
                    "${AppConfig.imageBaseURL}storage/uploads/$imageUrl";
                ;
                AppStorage.instance.setProfileImage(imageUrl);
              }

              update();
              Toast.success(message: value['message']);
            } else {
              Toast.error(message: value['message']);
            }
          },

          onError: (e) {
            Loader.hideLoader();

            Toast.error(message: e.toString());
          },
        );
  }

  void openImage(String url) {
    if (url.isEmpty) return;

    Get.to(
          () => FullImagePreviewScreen(
        imageUrl: url,
      ),
    );
  }

  void enableContactEdit() {
    isContactEditing = true;
    update();
  }

  void enableProfessionalEdit() {
    isProfessionalEditing = true;
    update();
  }

  void enablePersonalEdit() {
    isPersonalEditing = true;
    update();
  }

  void enableBankEdit() {
    isBankEditing = true;
    update();
  }

  void enableFamilyEdit() {
    isFamilyEditing = true;
    update();
  }

  void openIdCard() {
    loadCurrentUser();
    Get.to(() => const IDCardScreen(), binding: IDCardBinding());
  }

  void openContact() {
    loadCurrentUser();

    Get.to(() => const ContactScreen());
  }

  void openProfessional() {
    loadCurrentUser();

    Get.to(() => const ProfessionalScreen());
  }

  void openPersonal() {
    loadCurrentUser();

    Get.to(() => const PersonalScreen());
  }

  void openBank() {
    loadCurrentUser();

    Get.to(() => const BankScreen());
  }

  void openFamily() {
    loadCurrentUser();

    Get.to(() => const FamilyScreen());
  }

  void openApplyLeave() {
    Get.to(ApplyLeaveScreen(), binding: ApplyLeaveBinding());
  }

  void openHoliday() {
    Get.to(HolidayScreen(showAppBar: true));
  }

  void notificationSetting() {
    Get.to(NotificationScreen(showAppBar: true));
  }

  Future<void> updateContact() async {
    Loader.showLoader();

    final body = {
      "email": contactEmailController.text.trim(),

      "mobile": contactPhoneController.text.trim(),
    };

    profileRepository.updateContact(body).then((value) {
      Loader.hideLoader();

      if (value['success'] == true) {
        /// UPDATE MEMORY

        currentUser!.data.first.email = contactEmailController.text.trim();

        currentUser!.data.first.phoneNumber = contactPhoneController.text
            .trim();

        AppStorage.instance.setUserData(currentUser!);

        isContactEditing = false;

        update();

        Toast.success(message: value['message']);
      }
    });
  }

  Future<void> updateProfessional() async {
    Map<String, dynamic> body = {};
    Loader.showLoader();

    profileRepository.updateProfessional(body).then((value) {
      Loader.hideLoader();

      if (value['success'] == true) {
        ///
        currentUser!.professionalDetails.first.designation =
            designationController.text;

        currentUser!.professionalDetails.first.experience =
            experienceController.text;

        currentUser!.professionalDetails.first.skills = skillsController.text;

        AppStorage.instance.setUserData(currentUser!);

        Toast.success(message: value['message']);

        isContactEditing = false;

        update();
      }
    });
  }

  Future<void> updatePersonal() async {
    Map<String, dynamic> body = {};
    Loader.showLoader();

    profileRepository.updatePersonal(body).then((value) {
      Loader.hideLoader();

      if (value['success'] == true) {
        final personal = currentUser!.personalDetails.first;

        //personal.dob = dobController.text;

        personal.gender = genderController.text;

        // personal.bloodGroup =
        //     bloodGroupController.text;
        //
        // personal.personalEmail =
        //     personalEmailController.text;

        personal.address = addressController.text;

        AppStorage.instance.setUserData(currentUser!);

        Toast.success(message: value['message']);

        isContactEditing = false;

        update();
      }
    });
  }

  Future<void> pickPanCardImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    panCardImageFile = File(image.path);

    update();
  }

  Future<void> pickAadharCardImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    aadharCardImageFile = File(image.path);

    update();
  }

  bool isPdf(String url) {
    return url.toLowerCase().endsWith('.pdf');
  }

  void openPdf(String url) {
    Get.to(() => PdfPreviewScreen(pdfUrl: url));
  }

  Future<void> updateBank() async {
    Map<String, dynamic> body = {};
    Loader.showLoader();

    profileRepository.updateBank(body).then((value) {
      Loader.hideLoader();

      if (value['success'] == true) {
        final bank = currentUser!.bankDetails.first;

        bank.nameAsBank = accountHolderController.text;

        bank.bankName = bankNameController.text;

        bank.accountNo = accountNumberController.text;

        bank.ifscCode = ifscController.text;

        bank.branchName = branchController.text;

        bank.panCard = panController.text;

        bank.aadharCard = aadharController.text;

        AppStorage.instance.setUserData(currentUser!);

        Toast.success(message: value['message']);

        isContactEditing = false;

        update();
      }
    });
  }

  Future<void> updateFamily() async {
    Map<String, dynamic> body = {};
    Loader.showLoader();

    profileRepository.updateFamily(body).then((value) {
      Loader.hideLoader();

      if (value['success'] == true) {
        final family = currentUser!.familyDetails.first;

        family.fatherName = fatherNameController.text;

        family.motherName = motherNameController.text;

        family.alternateContact = alternateContactController.text;

        family.familyAddress = familyAddressController.text;

        AppStorage.instance.setUserData(currentUser!);

        Toast.success(message: value['message']);

        isContactEditing = false;

        update();
      }
    });
  }

  Future<void> logout() async {
    final confirm = await CommonConfirmationDialog.show(
      title: "Logout?",

      message: "Are you sure you want to logout?",

      positiveText: "Logout",
    );

    if (confirm) {
      AppStorage.instance.clearAll();
      Get.offAll(AuthScreen(), binding: AuthBinding());
    }
  }
}
