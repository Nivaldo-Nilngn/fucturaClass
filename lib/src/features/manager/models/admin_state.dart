import '../../../core/models/user_model.dart';
import 'course_model.dart';

class AdminDashboardState {
  final int totalStudents;
  final int totalProfessors;
  final int totalCourses;
  final int totalTurmas;
  final List<AppUser> students;
  final List<AppUser> professors;
  final List<Course> courses;
  final List<Turma> turmas;
  final AdminTab selectedTab;
  final String? selectedStudentId;
  final String? selectedCourseId;
  final String? selectedTurmaId;

  const AdminDashboardState({
    this.totalStudents = 0,
    this.totalProfessors = 0,
    this.totalCourses = 0,
    this.totalTurmas = 0,
    this.students = const [],
    this.professors = const [],
    this.courses = const [],
    this.turmas = const [],
    this.selectedTab = AdminTab.dashboard,
    this.selectedStudentId,
    this.selectedCourseId,
    this.selectedTurmaId,
  });

  AdminDashboardState copyWith({
    int? totalStudents,
    int? totalProfessors,
    int? totalCourses,
    int? totalTurmas,
    List<AppUser>? students,
    List<AppUser>? professors,
    List<Course>? courses,
    List<Turma>? turmas,
    AdminTab? selectedTab,
    String? selectedStudentId,
    String? selectedCourseId,
    String? selectedTurmaId,
  }) {
    return AdminDashboardState(
      totalStudents: totalStudents ?? this.totalStudents,
      totalProfessors: totalProfessors ?? this.totalProfessors,
      totalCourses: totalCourses ?? this.totalCourses,
      totalTurmas: totalTurmas ?? this.totalTurmas,
      students: students ?? this.students,
      professors: professors ?? this.professors,
      courses: courses ?? this.courses,
      turmas: turmas ?? this.turmas,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedStudentId: selectedStudentId ?? this.selectedStudentId,
      selectedCourseId: selectedCourseId ?? this.selectedCourseId,
      selectedTurmaId: selectedTurmaId ?? this.selectedTurmaId,
    );
  }

  AppUser? get selectedStudent {
    if (selectedStudentId == null) return null;
    try {
      return students.firstWhere((s) => s.id == selectedStudentId);
    } catch (_) {
      return null;
    }
  }

  Course? get selectedCourse {
    if (selectedCourseId == null) return null;
    try {
      return courses.firstWhere((c) => c.id == selectedCourseId);
    } catch (_) {
      return null;
    }
  }

  Turma? get selectedTurma {
    if (selectedTurmaId == null) return null;
    try {
      return turmas.firstWhere((t) => t.id == selectedTurmaId);
    } catch (_) {
      return null;
    }
  }

  List<Turma> turmasByCurso(String cursoId) {
    return turmas.where((t) => t.cursoId == cursoId).toList();
  }

  List<AppUser> professorsByTurma(String turmaId) {
    final turma = turmas.where((t) => t.id == turmaId).firstOrNull;
    if (turma == null) return [];
    return professors.where((p) => turma.professorIds.contains(p.id)).toList();
  }

  List<AppUser> studentsByTurma(String turmaId) {
    final turma = turmas.where((t) => t.id == turmaId).firstOrNull;
    if (turma == null) return [];
    return students.where((s) => turma.alunoIds.contains(s.id)).toList();
  }
}

enum AdminTab { dashboard, students, professors, courses }