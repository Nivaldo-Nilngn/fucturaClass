import 'academy_model.dart';

enum ChallengeStatus {
  active,
  completed,
  expired,
}

class Challenge {
  final String id;
  final String code;
  final String professorId;
  final String classId;
  final String title;
  final String description;
  final int points;
  final DateTime startsAt;
  final DateTime endsAt;
  final ChallengeStatus status;

  const Challenge({
    required this.id,
    required this.code,
    required this.professorId,
    required this.classId,
    required this.title,
    required this.description,
    required this.points,
    required this.startsAt,
    required this.endsAt,
    this.status = ChallengeStatus.active,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'professorId': professorId,
    'classId': classId,
    'title': title,
    'description': description,
    'points': points,
    'startsAt': startsAt.toIso8601String(),
    'endsAt': endsAt.toIso8601String(),
    'status': status.toString().split('.').last,
  };

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
    id: json['id'] as String,
    code: json['code'] as String,
    professorId: json['professorId'] as String,
    classId: json['classId'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    points: json['points'] as int,
    startsAt: DateTime.parse(json['startsAt'] as String),
    endsAt: DateTime.parse(json['endsAt'] as String),
    status: ChallengeStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
      orElse: () => ChallengeStatus.active,
    ),
  );
}

enum QuestionType {
  multipleChoice,
  openText,
}

enum QuestionDifficulty {
  easy,
  medium,
  hard,
}

class Question {
  final String id;
  final String category;
  final QuestionType type;
  final QuestionDifficulty difficulty;
  final String text;
  final String? correctAnswer; // Null for open text
  final List<String>? options; // Null for open text
  final String professorId;
  final DateTime createdAt;

  const Question({
    required this.id,
    required this.category,
    required this.type,
    required this.difficulty,
    required this.text,
    this.correctAnswer,
    this.options,
    required this.professorId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'type': type.toString().split('.').last,
    'difficulty': difficulty.toString().split('.').last,
    'text': text,
    'correctAnswer': correctAnswer,
    'options': options,
    'professorId': professorId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'] as String,
    category: json['category'] as String,
    type: QuestionType.values.firstWhere(
      (e) => e.toString().split('.').last == json['type'],
      orElse: () => QuestionType.multipleChoice,
    ),
    difficulty: QuestionDifficulty.values.firstWhere(
      (e) => e.toString().split('.').last == json['difficulty'],
      orElse: () => QuestionDifficulty.medium,
    ),
    text: json['text'] as String,
    correctAnswer: json['correctAnswer'] as String?,
    options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
    professorId: json['professorId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

class Exercise {
  final String id;
  final String code;
  final String title;
  final String text;
  final String professorId;
  final String classId;
  final DateTime createdAt;
  final DateTime dueDate;
  final int points;

  const Exercise({
    required this.id,
    required this.code,
    required this.title,
    required this.text,
    required this.professorId,
    required this.classId,
    required this.createdAt,
    required this.dueDate,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'title': title,
    'text': text,
    'professorId': professorId,
    'classId': classId,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'points': points,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json['id'] as String,
    code: json['code'] as String,
    title: json['title'] as String,
    text: json['text'] as String,
    professorId: json['professorId'] as String,
    classId: json['classId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    dueDate: DateTime.parse(json['dueDate'] as String),
    points: json['points'] as int,
  );
}

class Attendance {
  final String id;
  final String classId;
  final String studentId;
  final DateTime date;
  final DateTime time;
  final String registeredBy;
  final ClassModality modality;

  const Attendance({
    required this.id,
    required this.classId,
    required this.studentId,
    required this.date,
    required this.time,
    required this.registeredBy,
    required this.modality,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'classId': classId,
    'studentId': studentId,
    'date': date.toIso8601String(),
    'time': time.toIso8601String(),
    'registeredBy': registeredBy,
    'modality': modality.toString().split('.').last,
  };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json['id'] as String,
    classId: json['classId'] as String,
    studentId: json['studentId'] as String,
    date: DateTime.parse(json['date'] as String),
    time: DateTime.parse(json['time'] as String),
    registeredBy: json['registeredBy'] as String,
    modality: ClassModality.values.firstWhere(
      (e) => e.toString().split('.').last == json['modality'],
      orElse: () => ClassModality.presential,
    ),
  );
}

class TaughtContent {
  final String id;
  final String classId;
  final String professorId;
  final DateTime date;
  final String content;
  final String? observations;
  final String? materialUrl;

  const TaughtContent({
    required this.id,
    required this.classId,
    required this.professorId,
    required this.date,
    required this.content,
    this.observations,
    this.materialUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'classId': classId,
    'professorId': professorId,
    'date': date.toIso8601String(),
    'content': content,
    'observations': observations,
    'materialUrl': materialUrl,
  };

  factory TaughtContent.fromJson(Map<String, dynamic> json) => TaughtContent(
    id: json['id'] as String,
    classId: json['classId'] as String,
    professorId: json['professorId'] as String,
    date: DateTime.parse(json['date'] as String),
    content: json['content'] as String,
    observations: json['observations'] as String?,
    materialUrl: json['materialUrl'] as String?,
  );
}
