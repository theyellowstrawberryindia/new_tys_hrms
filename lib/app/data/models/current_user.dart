// To parse this JSON data, do
//
//     final currentUser = currentUserFromJson(jsonString);

import 'dart:convert';

CurrentUser currentUserFromJson(String str) =>
    CurrentUser.fromJson(json.decode(str));

String currentUserToJson(CurrentUser data) => json.encode(data.toJson());

String safeString(dynamic value) {
  if (value == null) return "";

  final text = value.toString();

  if (text == "null") return "";

  return text;
}

DateTime? safeDate(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();

  if (text.isEmpty ||
      text == "0" ||
      text == "00:00:0000" ||
      text == "0000-00-00") {
    return null;
  }

  try {
    return DateTime.parse(text);
  } catch (_) {
    return null;
  }
}

int safeInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  return int.tryParse(value.toString()) ?? 0;
}

class CurrentUser {
  List<Data> data;
  List<ProfessionalDetail> professionalDetails;
  List<PersonalDetail> personalDetails;
  List<FamilyDetail> familyDetails;
  List<BankDetail> bankDetails;
  List<dynamic> workExperience;
  List<dynamic> projects;
  List<dynamic> education;
  String message;

  CurrentUser({
    required this.data,
    required this.professionalDetails,
    required this.personalDetails,
    required this.familyDetails,
    required this.bankDetails,
    required this.workExperience,
    required this.projects,
    required this.education,
    required this.message,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
    data: json["data"] == null
        ? []
        : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),

    professionalDetails: json["professionalDetails"] == null
        ? []
        : List<ProfessionalDetail>.from(
            json["professionalDetails"].map(
              (x) => ProfessionalDetail.fromJson(x),
            ),
          ),

    personalDetails: json["personalDetails"] == null
        ? []
        : List<PersonalDetail>.from(
            json["personalDetails"].map((x) => PersonalDetail.fromJson(x)),
          ),

    familyDetails: json["familyDetails"] == null
        ? []
        : List<FamilyDetail>.from(
            json["familyDetails"].map((x) => FamilyDetail.fromJson(x)),
          ),

    bankDetails: json["bankDetails"] == null
        ? []
        : List<BankDetail>.from(
            json["bankDetails"].map((x) => BankDetail.fromJson(x)),
          ),

    workExperience: json["workExperience"] == null
        ? []
        : List<dynamic>.from(json["workExperience"].map((x) => x)),

    projects: json["projects"] == null
        ? []
        : List<dynamic>.from(json["projects"].map((x) => x)),

    education: json["education"] == null
        ? []
        : List<dynamic>.from(json["education"].map((x) => x)),

    message: safeString(json["message"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "professionalDetails": List<dynamic>.from(
      professionalDetails.map((x) => x.toJson()),
    ),
    "personalDetails": List<dynamic>.from(
      personalDetails.map((x) => x.toJson()),
    ),
    "familyDetails": List<dynamic>.from(familyDetails.map((x) => x.toJson())),
    "bankDetails": List<dynamic>.from(bankDetails.map((x) => x.toJson())),
    "workExperience": List<dynamic>.from(workExperience.map((x) => x)),
    "projects": List<dynamic>.from(projects.map((x) => x)),
    "education": List<dynamic>.from(education.map((x) => x)),
    "message": message,
  };
}

class BankDetail {
  int id;
  String userid;
  String bankName;
  String accountNo;
  String ifscCode;
  String branchName;
  String bankAddress;
  String nameAsBank;
  String panCard;
  String aadharCard;
  DateTime createdAt;
  DateTime updatedAt;
  String status;
  String aadharImg;
  String panImg;
  String bankPassbookImg;
  String label;

  BankDetail({
    required this.id,
    required this.userid,
    required this.bankName,
    required this.accountNo,
    required this.ifscCode,
    required this.branchName,
    required this.nameAsBank,
    required this.bankAddress,
    required this.panCard,
    required this.aadharCard,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.aadharImg,
    required this.panImg,
    required this.bankPassbookImg,
    required this.label,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    id: safeInt(json["id"]),
    userid: safeString(json["userid"]),
    bankName: safeString(json["bank_name"]),
    accountNo: safeString(json["account_no"]),
    ifscCode: safeString(json["ifsc_code"]),
    branchName: safeString(json["branch_name"]),
    nameAsBank: json["name_as_bank"],
    bankAddress: safeString(json["bank_address"]),
    panCard: safeString(json["pan_card"]),
    aadharCard: safeString(json["aadhar_card"]),

    createdAt: safeDate(json["created_at"]) ?? DateTime.now(),

    updatedAt: safeDate(json["updated_at"]) ?? DateTime.now(),

    status: safeString(json["status"]),

    aadharImg: safeString(json["aadhar_img"]),

    panImg: safeString(json["pan_img"]),

    bankPassbookImg: safeString(json["bank_passbook_img"]),

    label: safeString(json["label"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "bank_name": bankName,
    "account_no": accountNo,
    "ifsc_code": ifscCode,
    "branch_name": branchName,
    "name_as_bank": nameAsBank,
    "bank_address": bankAddress,
    "pan_card": panCard,
    "aadhar_card": aadharCard,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "status": status,
    "aadhar_img": aadharImg,
    "pan_img": panImg,
    "bank_passbook_img": bankPassbookImg,
    "label": label,
  };
}

class Data {
  int id;
  int userid;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  dynamic emailVerifiedAt;
  String status;
  String type;
  String workLocation;
  String userType;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.userid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.emailVerifiedAt,
    required this.status,
    required this.type,
    required this.workLocation,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userid: json["userid"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    emailVerifiedAt: json["email_verified_at"],
    status: json["status"],
    type: json["type"],
    workLocation: json["work_location"],
    userType: json["user_type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone_number": phoneNumber,
    "email_verified_at": emailVerifiedAt,
    "status": status,
    "type": type,
    "work_location": workLocation,
    "user_type": userType,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class FamilyDetail {
  int id;
  String userid;
  String fatherName;
  String motherName;
  String personalEmail;
  String alternateContact;
  String familyAddress;
  DateTime createdAt;
  DateTime updatedAt;

  FamilyDetail({
    required this.id,
    required this.userid,
    required this.fatherName,
    required this.motherName,
    required this.personalEmail,
    required this.alternateContact,
    required this.familyAddress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FamilyDetail.fromJson(Map<String, dynamic> json) => FamilyDetail(
    id: json["id"],
    userid: json["userid"],
    fatherName: json["father_name"],
    motherName: json["mother_name"],
    personalEmail: json["personal_email"],
    alternateContact: json["alternate_contact"],
    familyAddress: json["family_address"],
    createdAt: safeDate(json["created_at"]) ?? DateTime.now(),
    updatedAt: safeDate(json["updated_at"]) ?? DateTime.now(),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "father_name": fatherName,
    "mother_name": motherName,
    "personal_email": personalEmail,
    "alternate_contact": alternateContact,
    "family_address": familyAddress,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class PersonalDetail {
  int id;
  String userid;
  String src;
  String mimeType;
  String gender;
  DateTime? dob;
  String bio;
  String address;
  String address2;
  String state;
  String city;
  String zipcode;
  String country;
  String addressType;
  DateTime createdAt;
  DateTime updatedAt;

  PersonalDetail({
    required this.id,
    required this.userid,
    required this.src,
    required this.mimeType,
    required this.gender,
    required this.dob,
    required this.bio,
    required this.address,
    required this.address2,
    required this.state,
    required this.city,
    required this.zipcode,
    required this.country,
    required this.addressType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PersonalDetail.fromJson(Map<String, dynamic> json) => PersonalDetail(
    id: safeInt(json["id"]),
    userid: safeString(json["userid"]),
    src: safeString(json["src"]),
    mimeType: safeString(json["mime_type"]),
    gender: safeString(json["gender"]),
    dob: safeDate(json["dob"]),
    bio: safeString(json["bio"]),
    address: safeString(json["address"]),
    address2: safeString(json["address2"]),
    state: safeString(json["state"]),
    city: safeString(json["city"]),
    zipcode: safeString(json["zipcode"]),
    country: safeString(json["country"]),
    addressType: safeString(json["address_type"]),
    createdAt: safeDate(json["created_at"]) ?? DateTime.now(),
    updatedAt: safeDate(json["updated_at"]) ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "src": src,
    "mime_type": mimeType,
    "gender": gender,
    "dob": dob?.toIso8601String(),

    "bio": bio,
    "address": address,
    "address2": address2,
    "state": state,
    "city": city,
    "zipcode": zipcode,
    "country": country,
    "address_type": addressType,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class ProfessionalDetail {
  int id;
  String userid;
  String designation;
  String prevExperience;
  String experience;
  int salary;
  String skills;
  String cvIntro;
  DateTime? joiningDate;
  DateTime? permanentConfirmDate;
  DateTime? terminationDate;
  String terminationReason;
  DateTime createdAt;
  DateTime updatedAt;
  int isPolicyAccepted;

  ProfessionalDetail({
    required this.id,
    required this.userid,
    required this.designation,
    required this.prevExperience,
    required this.experience,
    required this.salary,
    required this.skills,
    required this.cvIntro,
    required this.joiningDate,
    required this.permanentConfirmDate,
    required this.terminationDate,
    required this.terminationReason,
    required this.createdAt,
    required this.updatedAt,
    required this.isPolicyAccepted,
  });

  factory ProfessionalDetail.fromJson(Map<String, dynamic> json) =>
      ProfessionalDetail(
        id: safeInt(json["id"]),
        userid: safeString(json["userid"]),
        designation: safeString(json["designation"]),
        prevExperience: safeString(json["prev_experience"]),
        experience: safeString(json["experience"]),
        salary: safeInt(json["salary"]),
        skills: safeString(json["skills"]),
        cvIntro: safeString(json["cv_intro"]),

        joiningDate: safeDate(json["joining_date"]),

        permanentConfirmDate: safeDate(json["permanent_confirm_date"]),

        terminationDate: safeDate(json["termination_date"]),

        terminationReason: safeString(json["termination_reason"]),

        createdAt: safeDate(json["created_at"]) ?? DateTime.now(),

        updatedAt: safeDate(json["updated_at"]) ?? DateTime.now(),

        isPolicyAccepted: safeInt(json["is_policy_accepted"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "designation": designation,
    "prev_experience": prevExperience,
    "experience": experience,
    "salary": salary,
    "skills": skills,
    "cv_intro": cvIntro,
    "joining_date": joiningDate?.toIso8601String(),

    "permanent_confirm_date": permanentConfirmDate?.toIso8601String(),

    "termination_date": terminationDate?.toIso8601String(),
    "termination_reason": terminationReason,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_policy_accepted": isPolicyAccepted,
  };
}


class Education {
  int id;
  String userid;
  String universityName;
  String courseName;
  DateTime startDate;
  DateTime endDate;
  String grade;
  DateTime createdAt;
  DateTime updatedAt;

  Education({
    required this.id,
    required this.userid,
    required this.universityName,
    required this.courseName,
    required this.startDate,
    required this.endDate,
    required this.grade,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json["id"],
    userid: json["userid"],
    universityName: json["university_name"],
    courseName: json["course_name"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    grade: json["grade"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "university_name": universityName,
    "course_name": courseName,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "grade": grade,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}


class Project {
  int id;
  String userid;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  DateTime updatedAt;

  Project({
    required this.id,
    required this.userid,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json["id"],
    userid: json["userid"],
    title: json["title"],
    description: json["description"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "title": title,
    "description": description,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class WorkExperience {
  int id;
  String userid;
  String componyName;
  String designation;
  DateTime startDate;
  DateTime endDate;
  String exp;
  DateTime createdAt;
  DateTime updatedAt;

  WorkExperience({
    required this.id,
    required this.userid,
    required this.componyName,
    required this.designation,
    required this.startDate,
    required this.endDate,
    required this.exp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
    id: json["id"],
    userid: json["userid"],
    componyName: json["compony_name"],
    designation: json["designation"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    exp: json["exp"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "compony_name": componyName,
    "designation": designation,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "exp": exp,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}