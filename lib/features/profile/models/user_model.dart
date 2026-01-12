class UserModel {
  final String id;
  final String fullName;
  final String contactNo;
  final String email;
  final String dateOfBirth; // Keep as string for now or parse
  final String city;
  final String caste;
  final String currentQualification;
  final String fieldOfStudy;
  final String currentStatus;
  final String institute;
  final String userProfile;
  final String adhaarCard;
  final String incomeCertificate;
  final String obcCertificate;
  final String marksheets;
  final String notes;
  final String gender; // Not in JSON but in UI, might need fallback
  final int age; // Not in JSON explicitly as simple int, derived from DOB usually but UI expects age.
  
  UserModel({
    required this.id,
    required this.fullName,
    required this.contactNo,
    required this.email,
    required this.dateOfBirth,
    required this.city,
    required this.caste,
    required this.currentQualification,
    required this.fieldOfStudy,
    required this.currentStatus,
    required this.institute,
    required this.userProfile,
    required this.adhaarCard,
    required this.incomeCertificate,
    required this.obcCertificate,
    required this.marksheets,
    required this.notes,
    this.gender = 'Not Specified',
    this.age = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String getString(dynamic val) {
      if (val == null) return '';
      if (val is String) return val;
      if (val is List && val.isNotEmpty) return val.first.toString();
      if (val is List && val.isEmpty) return '';
      return val.toString();
    }

    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['FullName'] ?? '',
      contactNo: (json['ContactNo'] ?? '').toString(),
      email: json['Email'] ?? '',
      dateOfBirth: json['DateofBirth'] ?? '',
      city: json['City'] ?? '',
      caste: json['Caste'] ?? '',
      currentQualification: json['CurrentQualification'] ?? '',
      fieldOfStudy: json['FieldofStudy'] ?? '',
      currentStatus: json['CurrentStatus'] ?? '',
      institute: json['Institute'] ?? '',
      userProfile: getString(json['userProfile']),
      adhaarCard: getString(json['AdhaarCard']),
      incomeCertificate: getString(json['IncomeCertificate']),
      obcCertificate: getString(json['OBCCertificate']),
      marksheets: getString(json['Marksheets']),
      notes: json['Notes'] ?? '',
      // Age calculation logic could go here if DOB is valid
    );
  }
}
