enum UserRole {
  admin,
  secretary,
  professor,
  student,
}

class AppUser {
  final String id;
  final String name;
  final String cpf;
  final UserRole role;
  final String? academyId;
  final String? classId;
  final DateTime createdAt;
  final bool isActive;
  final String? phone;
  final String? address;
  final String? city;
  final DateTime? birthDate;
  final String? motherName;
  final String? fatherName;
  final String? financialResponsible;
  final String? legalResponsible;
  final String? email;
  final bool isProfileComplete;

  const AppUser({
    required this.id,
    required this.name,
    required this.cpf,
    required this.role,
    this.academyId,
    this.classId,
    required this.createdAt,
    this.isActive = true,
    this.phone,
    this.address,
    this.city,
    this.birthDate,
    this.motherName,
    this.fatherName,
    this.financialResponsible,
    this.legalResponsible,
    this.email,
    this.isProfileComplete = false,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isSecretary => role == UserRole.secretary;
  bool get isProfessor => role == UserRole.professor;
  bool get isStudent => role == UserRole.student;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'role': role.toString().split('.').last,
      'academyId': academyId,
      'classId': classId,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'phone': phone,
      'address': address,
      'city': city,
      'birthDate': birthDate?.toIso8601String(),
      'motherName': motherName,
      'fatherName': fatherName,
      'financialResponsible': financialResponsible,
      'legalResponsible': legalResponsible,
      'email': email,
      'isProfileComplete': isProfileComplete,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      cpf: json['cpf'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.student,
      ),
      academyId: json['academyId'] as String?,
      classId: json['classId'] as String?,
      createdAt: json['createdAt'] is String 
          ? DateTime.parse(json['createdAt'] as String) 
          : (json['createdAt'] as dynamic).toDate(),
      isActive: json['isActive'] as bool? ?? true,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      birthDate: json['birthDate'] != null
          ? (json['birthDate'] is String
              ? DateTime.parse(json['birthDate'] as String)
              : (json['birthDate'] as dynamic).toDate())
          : null,
      motherName: json['motherName'] as String?,
      fatherName: json['fatherName'] as String?,
      financialResponsible: json['financialResponsible'] as String?,
      legalResponsible: json['legalResponsible'] as String?,
      email: json['email'] as String?,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
    );
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? cpf,
    UserRole? role,
    String? academyId,
    String? classId,
    DateTime? createdAt,
    bool? isActive,
    String? phone,
    String? address,
    String? city,
    DateTime? birthDate,
    String? motherName,
    String? fatherName,
    String? financialResponsible,
    String? legalResponsible,
    String? email,
    bool? isProfileComplete,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      role: role ?? this.role,
      academyId: academyId ?? this.academyId,
      classId: classId ?? this.classId,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      birthDate: birthDate ?? this.birthDate,
      motherName: motherName ?? this.motherName,
      fatherName: fatherName ?? this.fatherName,
      financialResponsible: financialResponsible ?? this.financialResponsible,
      legalResponsible: legalResponsible ?? this.legalResponsible,
      email: email ?? this.email,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}
