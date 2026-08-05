enum ClassModality {
  presential,
  online,
  hybrid,
}

enum ClassStatus {
  active,
  closed,
}

class Academy {
  final String id;
  final String name;
  final List<String> modules;

  const Academy({
    required this.id,
    required this.name,
    this.modules = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'modules': modules,
  };

  factory Academy.fromJson(Map<String, dynamic> json) => Academy(
    id: json['id'] as String,
    name: json['name'] as String,
    modules: (json['modules'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  );
}

class Unit {
  final String id;
  final String name;
  final String city;
  final String address;
  final String phone;
  final String responsibleName;

  const Unit({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.phone,
    required this.responsibleName,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'city': city,
    'address': address,
    'phone': phone,
    'responsibleName': responsibleName,
  };

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    id: json['id'] as String,
    name: json['name'] as String,
    city: json['city'] as String,
    address: json['address'] as String,
    phone: json['phone'] as String,
    responsibleName: json['responsibleName'] as String,
  );
}

class ClassModel {
  final String id;
  final String code;
  final String name;
  final String description;
  final String academyId;
  final String unitId;
  final List<String> professorIds;
  final String schedule;
  final List<String> daysOfWeek;
  final ClassModality modality;
  final ClassStatus status;

  const ClassModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.academyId,
    required this.unitId,
    required this.professorIds,
    required this.schedule,
    required this.daysOfWeek,
    required this.modality,
    this.status = ClassStatus.active,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'description': description,
    'academyId': academyId,
    'unitId': unitId,
    'professorIds': professorIds,
    'schedule': schedule,
    'daysOfWeek': daysOfWeek,
    'modality': modality.toString().split('.').last,
    'status': status.toString().split('.').last,
  };

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    academyId: json['academyId'] as String,
    unitId: json['unitId'] as String,
    professorIds: (json['professorIds'] as List<dynamic>).map((e) => e as String).toList(),
    schedule: json['schedule'] as String,
    daysOfWeek: (json['daysOfWeek'] as List<dynamic>).map((e) => e as String).toList(),
    modality: ClassModality.values.firstWhere(
      (e) => e.toString().split('.').last == json['modality'],
      orElse: () => ClassModality.presential,
    ),
    status: ClassStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => ClassStatus.active,
    ),
  );
}

class Enrollment {
  final String id;
  final String studentId;
  final String classId;
  final DateTime enrolledAt;
  final bool isActive;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.enrolledAt,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'classId': classId,
    'enrolledAt': enrolledAt.toIso8601String(),
    'isActive': isActive,
  };

  factory Enrollment.fromJson(Map<String, dynamic> json) => Enrollment(
    id: json['id'] as String,
    studentId: json['studentId'] as String,
    classId: json['classId'] as String,
    enrolledAt: DateTime.parse(json['enrolledAt'] as String),
    isActive: json['isActive'] as bool? ?? true,
  );
}
