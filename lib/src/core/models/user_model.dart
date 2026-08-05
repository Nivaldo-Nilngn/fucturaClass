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

  const AppUser({
    required this.id,
    required this.name,
    required this.cpf,
    required this.role,
    this.academyId,
    this.classId,
    required this.createdAt,
    this.isActive = true,
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
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
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
    );
  }
}
