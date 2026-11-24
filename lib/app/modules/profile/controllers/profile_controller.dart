/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:37 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:37 pm
 *
 */
import 'package:dio/dio.dart';
import 'package:hrms_ys/app/core/utils/app_storage.dart';
import 'package:hrms_ys/app/modules/auth/bindings/auth_binding.dart';
import 'package:hrms_ys/app/modules/profile/bindings/privacy_policy_binding.dart';
import 'package:hrms_ys/app/modules/profile/bindings/project_details_binding.dart';
import 'package:hrms_ys/app/modules/profile/bindings/work_experience_binding.dart';
import 'package:hrms_ys/app/modules/profile/data/repositories/profile_repository.dart';
import 'package:hrms_ys/app/modules/leave/views/apply_leave_screen.dart';
import 'package:hrms_ys/app/modules/auth/views/auth_screen.dart';
import 'package:hrms_ys/app/modules/profile/views/privacy_policy_screen.dart';
import 'package:hrms_ys/app/modules/updates/views/holiday_screen.dart';
import 'package:hrms_ys/app/modules/updates/views/notification_screen.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../shared/packages.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../core/configs/app_configs.dart';
import '../views/bank_screen.dart';
import '../views/contact_screen.dart';
import '../views/education_screen.dart';
import '../views/family_screen.dart';
import '../views/idcard_screen.dart';
import '../views/personal_screen.dart';
import '../views/professional_screen.dart';
import '../views/project_details_screen.dart';
import '../views/work_experience_screen.dart';
import '../../../shared/widgets/common_confirmation_dialog.dart';
import '../../../shared/widgets/common_image_preview.dart';
import '../../../shared/widgets/pdf_preview_screen.dart';
import '../../leave/bindings/apply_leave_binding.dart';
import '../bindings/education_binding.dart';
import '../bindings/idcard_binding.dart';
import '../../../data/models/current_user.dart';

class ProfileController extends GetxController {
  ProfileController({ProfileRepository? repository})
    : profileRepository = repository ?? ProfileRepository();

  final ProfileRepository profileRepository;

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
  bool isSavingBank = false;
  bool bankSaveSucceeded = false;
  String? bankSaveMessage;
  final bankFieldErrors = <String, String>{};

  bool get hasBankDetails => currentUser?.bankDetails.isNotEmpty ?? false;

  bool isFamilyEditing = false;

  bool isEducationEditing = false;

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
  String appVersion = "";


  Future<void> loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    appVersion = "Version ${info.version} (${info.buildNumber})";
    update();
  }

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
    loadAppVersion();
    super.onInit();
  }

  @override
  void onReady() {
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

    final personal = currentUser!.personalDetails.isNotEmpty
        ? currentUser!.personalDetails.first
        : null;

    final professional = currentUser!.professionalDetails.isNotEmpty
        ? currentUser!.professionalDetails.first
        : null;

    designation = professional?.designation ?? "";
    final profileImage = personal?.src ?? "";
    profileImageUrl = profileImage.isEmpty
        ? ""
        : "${AppConfig.imageBaseURL}storage/uploads/$profileImage";

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
    genderController.text = formatGender(personal?.gender);


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

    panCardImageUrl = _bankDocumentUrl(bank?.panImg ?? "");
    aadharCardImageUrl = _bankDocumentUrl(bank?.aadharImg ?? "");

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

        child: Material(
          type: MaterialType.transparency,
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

      compressFormat: ImageCompressFormat.jpg,

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Picture',

          lockAspectRatio: true,

          hideBottomControls: false,
        ),

        IOSUiSettings(
          title: 'Crop Profile Picture',
          cropStyle: CropStyle.circle,
        ),
      ],
    );

    if (cropped == null) return;

    final file = File(cropped.path);

    const maxSizeInBytes = 1048 * 1024;

    final fileSizeInBytes = await file.length();

    if (fileSizeInBytes > maxSizeInBytes) {
      Toast.error(
        message: "Image is too large. Please choose a smaller image (max 1 MB).",
      );
      return;
    }

    selectedProfileImage = file;

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
    bankFieldErrors.clear();
    bankSaveMessage = null;
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
    if (isSavingBank) return;
    if (!isBankEditing) loadCurrentUser();

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

  void openEducation() {
    loadCurrentUser();

    Get.to(
          () => const EducationDetailsScreen(),
      binding: EducationDetailsBinding(),
    );  }

  void openProject() {
    loadCurrentUser();
    Get.to(
          () => const ProjectDetailsScreen(),
      binding: ProjectDetailsBinding(),
    );

  }

  void openWorkExperience() {
    loadCurrentUser();
    Get.to(
          () => const WorkExperienceScreen(),
      binding: WorkExperienceBinding(),
    );

  }

  void openPrivacyPolicy() {
    loadCurrentUser();
    Get.to(
          () => const PrivacyPolicyScreen(),
      binding: PrivacyPolicyBinding(),
    );

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
    if (isSavingBank) return;
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null || isSavingBank) return;

    panCardImageFile = File(image.path);

    update();
  }

  Future<void> pickAadharCardImage() async {
    if (isSavingBank) return;
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null || isSavingBank) return;

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
    if (isSavingBank || !isBankEditing) return;
    bankFieldErrors.clear();
    bankSaveMessage = null;
    bankSaveSucceeded = false;

    final fields = {
      "name_as_bank": accountHolderController.text.trim(),
      "bank_name": bankNameController.text.trim(),
      "account_no": accountNumberController.text.trim(),
      "ifsc_code": ifscController.text.trim().toUpperCase(),
      "branch_name": branchController.text.trim(),
      "pan_card": panController.text.trim().toUpperCase(),
      "aadhar_card": aadharController.text.trim(),
    };
    _validateBankFields(fields);
    if (bankFieldErrors.isNotEmpty) {
      bankSaveMessage = "Check the highlighted fields and try again.";
      update();
      return;
    }

    final user = currentUser;
    final existingBank = user?.bankDetails.firstOrNull;
    final userId = existingBank?.userid.trim() ?? "";
    final employeeId = user?.data.firstOrNull?.userid ?? 0;
    if (user == null || (userId.isEmpty && employeeId <= 0)) {
      bankSaveMessage =
          "Employee details are unavailable. Reopen your profile and try again.";
      update();
      return;
    }
    final body = {...fields, "userid": userId.isEmpty ? "$employeeId" : userId};
    isSavingBank = true;
    update();

    try {
      final response = await profileRepository.updateBank(
        body,
        panCardImageFile: panCardImageFile,
        aadharCardImageFile: aadharCardImageFile,
      );
      if (response['success'] != true) {
        _showBankSaveError(response);
        return;
      }

      final data = response['data'];
      final bank = BankDetail.fromJson({
        ...?existingBank?.toJson(),
        ...body,
        if (data is Map)
          for (final key in [
            'id',
            'pan_img',
            'aadhar_img',
            'created_at',
            'updated_at',
          ])
            if (data[key] != null) key: data[key],
      });
      user.bankDetails = [bank, ...user.bankDetails.skip(1)];
      ifscController.text = bank.ifscCode;
      panController.text = bank.panCard;
      panCardImageUrl = _bankDocumentUrl(bank.panImg);
      aadharCardImageUrl = _bankDocumentUrl(bank.aadharImg);
      panCardImageFile = null;
      aadharCardImageFile = null;
      isBankEditing = false;
      bankSaveSucceeded = true;
      bankSaveMessage = "Bank details saved.";
      try {
        await AppStorage.instance.setUserData(user);
      } catch (_) {
        bankSaveMessage =
            "Bank details were saved, but the local copy could not be updated.";
      }
    } on DioException catch (error) {
      final code = error.response?.statusCode;
      if (code == 401 || code == 403) {
        bankSaveMessage =
            "You don’t have access to save these bank details. Sign in again or contact HR.";
      } else if (code != null && code >= 400 && code < 500) {
        _showBankSaveError(error.response?.data);
      } else if (error.type == DioExceptionType.connectionError) {
        bankSaveMessage =
            "Couldn’t connect. Check your internet connection and try again.";
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        bankSaveMessage =
            "The request timed out. Check your saved bank details before retrying.";
      } else {
        _showBankSaveError(null);
      }
    } catch (_) {
      _showBankSaveError(null);
    } finally {
      isSavingBank = false;
      update();
    }
  }

  String _bankDocumentUrl(String path) =>
      path.isEmpty ? "" : "${AppConfig.imageBaseURL}storage/$path";

  void _validateBankFields(Map<String, String> fields) {
    const requiredFields = {
      'name_as_bank': 'Account holder name',
      'bank_name': 'Bank name',
      'account_no': 'Account number',
      'ifsc_code': 'IFSC code',
      'branch_name': 'Branch name',
    };
    for (final entry in requiredFields.entries) {
      if (fields[entry.key]!.isEmpty) {
        bankFieldErrors[entry.key] = "Enter the ${entry.value.toLowerCase()}.";
      }
    }
    final account = fields['account_no']!;
    final ifsc = fields['ifsc_code']!;
    final pan = fields['pan_card']!;
    final aadhaar = fields['aadhar_card']!;
    if (account.isNotEmpty && !RegExp(r'^\d+$').hasMatch(account)) {
      bankFieldErrors['account_no'] = "Use digits only for the account number.";
    }
    if (ifsc.isNotEmpty && !RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifsc)) {
      bankFieldErrors['ifsc_code'] =
          "Enter an 11-character IFSC code, such as ABCD0123456.";
    }
    if (pan.isNotEmpty && !RegExp(r'^[A-Z]{5}\d{4}[A-Z]$').hasMatch(pan)) {
      bankFieldErrors['pan_card'] = "Enter a valid 10-character PAN.";
    }
    if (aadhaar.isNotEmpty && !RegExp(r'^\d{12}$').hasMatch(aadhaar)) {
      bankFieldErrors['aadhar_card'] = "Enter a 12-digit Aadhaar number.";
    }
  }

  void _showBankSaveError(Object? response) {
    final errors = response is Map ? response['errors'] : null;
    if (errors is Map) {
      for (final key in [
        'name_as_bank',
        'bank_name',
        'account_no',
        'ifsc_code',
        'branch_name',
        'pan_card',
        'aadhar_card',
        'pan_img',
        'aadhar_img',
      ]) {
        final fieldError = errors[key];
        final message = fieldError is List
            ? fieldError.firstOrNull
            : fieldError;
        if (message is String && message.trim().isNotEmpty) {
          bankFieldErrors[key] = message.trim();
        }
      }
    }
    final message = response is Map
        ? (response['message'] ?? response['error'] ?? response['errormsg'])
        : null;
    bankSaveMessage = message is String && message.trim().isNotEmpty
        ? message.trim()
        : bankFieldErrors.isNotEmpty
        ? "Check the highlighted fields and try again."
        : "Couldn’t save bank details. Try again.";
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
  String formatGender(String? gender) {
    switch (gender?.toUpperCase()) {
      case "ML":
        return "Male";

      case "FL":
        return "Female";

      case "OT":
        return "Other";

      default:
        return gender ?? "-";
    }
  }

}