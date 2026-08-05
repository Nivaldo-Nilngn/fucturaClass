import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/admin_state.dart';
import '../models/course_model.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../../../core/models/user_model.dart';

class AdminViewModel extends Notifier<AdminDashboardState> {
  @override
  AdminDashboardState build() {
    return _loadData();
  }

  AdminDashboardState _loadData() {
    final authState = ref.read(authViewModelProvider);
    final users = authState.user != null
        ? ref.read(authViewModelProvider.notifier).users
        : <AppUser>[];

    final students = users.where((u) => u.role == UserRole.student).toList();
    final professors = users.where((u) => u.role == UserRole.professor).toList();

    return AdminDashboardState(
      totalStudents: students.length,
      totalProfessors: professors.length,
      totalCourses: _mockCourses.length,
      totalTurmas: _mockTurmas.length,
      students: students,
      professors: professors,
      courses: _mockCourses,
      turmas: _mockTurmas,
    );
  }

  void selectTab(AdminTab tab) {
    state = AdminDashboardState(
      totalStudents: state.totalStudents,
      totalProfessors: state.totalProfessors,
      totalCourses: state.totalCourses,
      totalTurmas: state.totalTurmas,
      students: state.students,
      professors: state.professors,
      courses: state.courses,
      turmas: state.turmas,
      selectedTab: tab,
    );
  }

  void selectStudent(String? studentId) {
    state = AdminDashboardState(
      totalStudents: state.totalStudents,
      totalProfessors: state.totalProfessors,
      totalCourses: state.totalCourses,
      totalTurmas: state.totalTurmas,
      students: state.students,
      professors: state.professors,
      courses: state.courses,
      turmas: state.turmas,
      selectedTab: state.selectedTab,
      selectedStudentId: studentId,
      selectedCourseId: state.selectedCourseId,
      selectedTurmaId: state.selectedTurmaId,
    );
  }

  void selectCourse(String? courseId) {
    state = AdminDashboardState(
      totalStudents: state.totalStudents,
      totalProfessors: state.totalProfessors,
      totalCourses: state.totalCourses,
      totalTurmas: state.totalTurmas,
      students: state.students,
      professors: state.professors,
      courses: state.courses,
      turmas: state.turmas,
      selectedTab: state.selectedTab,
      selectedStudentId: state.selectedStudentId,
      selectedCourseId: courseId,
      selectedTurmaId: null,
    );
  }

  void selectTurma(String? turmaId) {
    state = AdminDashboardState(
      totalStudents: state.totalStudents,
      totalProfessors: state.totalProfessors,
      totalCourses: state.totalCourses,
      totalTurmas: state.totalTurmas,
      students: state.students,
      professors: state.professors,
      courses: state.courses,
      turmas: state.turmas,
      selectedTab: state.selectedTab,
      selectedStudentId: state.selectedStudentId,
      selectedCourseId: state.selectedCourseId,
      selectedTurmaId: turmaId,
    );
  }

  // === Student CRUD ===

  void addStudent({required String name, required String email, String? turma}) {
    // TODO: Implement user registration via Firebase Secondary App
    _refresh();
  }

  void removeStudent(String id) {
    // TODO: Implement user removal via Firebase
    _refresh();
  }

  // === Professor CRUD ===

  void addProfessor({required String name, required String email, String? turma}) {
    // TODO: Implement user registration via Firebase Secondary App
    _refresh();
  }

  void removeProfessor(String id) {
    // TODO: Implement user removal via Firebase
    _refresh();
  }

  // === Course CRUD ===

  void addCourse({required String name, required String description}) {
    final newCourse = Course(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
    );
    _mockCourses.add(newCourse);
    _refresh();
  }

  void removeCourse(String id) {
    _mockCourses.removeWhere((c) => c.id == id);
    _mockTurmas.removeWhere((t) => t.cursoId == id);
    _refresh();
  }

  // === Turma CRUD ===

  void addTurma({
    required String cursoId,
    required String nome,
    required int mes,
    required int ano,
    DateTime? dataInicio,
    DateTime? dataFim,
  }) {
    final newTurma = Turma(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cursoId: cursoId,
      nome: nome,
      mes: mes,
      ano: ano,
      dataInicio: dataInicio,
      dataFim: dataFim,
      status: TurmaStatus.planejada,
    );
    _mockTurmas.add(newTurma);
    _refresh();
  }

  void updateTurma(Turma turma) {
    final index = _mockTurmas.indexWhere((t) => t.id == turma.id);
    if (index != -1) {
      _mockTurmas[index] = turma;
      _refresh();
    }
  }

  void removeTurma(String id) {
    _mockTurmas.removeWhere((t) => t.id == id);
    _refresh();
  }

  // === Turma Professor Management ===

  void addProfessorToTurma(String turmaId, String professorId) {
    final index = _mockTurmas.indexWhere((t) => t.id == turmaId);
    if (index == -1) return;

    final turma = _mockTurmas[index];
    if (turma.professorIds.contains(professorId)) return;

    _mockTurmas[index] = turma.copyWith(
      professorIds: [...turma.professorIds, professorId],
    );
    _refresh();
  }

  void removeProfessorFromTurma(String turmaId, String professorId) {
    final index = _mockTurmas.indexWhere((t) => t.id == turmaId);
    if (index == -1) return;

    final turma = _mockTurmas[index];
    _mockTurmas[index] = turma.copyWith(
      professorIds: turma.professorIds.where((id) => id != professorId).toList(),
    );
    _refresh();
  }

  // === Turma Student Management ===

  void addStudentToTurma(String turmaId, String alunoId) {
    final index = _mockTurmas.indexWhere((t) => t.id == turmaId);
    if (index == -1) return;

    final turma = _mockTurmas[index];
    if (turma.alunoIds.contains(alunoId)) return;

    _mockTurmas[index] = turma.copyWith(
      alunoIds: [...turma.alunoIds, alunoId],
    );
    _refresh();
  }

  void removeStudentFromTurma(String turmaId, String alunoId) {
    final index = _mockTurmas.indexWhere((t) => t.id == turmaId);
    if (index == -1) return;

    final turma = _mockTurmas[index];
    _mockTurmas[index] = turma.copyWith(
      alunoIds: turma.alunoIds.where((id) => id != alunoId).toList(),
    );
    _refresh();
  }

  // === Refresh ===

  void _refresh() {
    final authState = ref.read(authViewModelProvider);
    final users = authState.user != null
        ? ref.read(authViewModelProvider.notifier).users
        : <AppUser>[];

    final students = users.where((u) => u.role == UserRole.student).toList();
    final professors = users.where((u) => u.role == UserRole.professor).toList();

    state = AdminDashboardState(
      totalStudents: students.length,
      totalProfessors: professors.length,
      totalCourses: _mockCourses.length,
      totalTurmas: _mockTurmas.length,
      students: students,
      professors: professors,
      courses: List.unmodifiable(_mockCourses),
      turmas: List.unmodifiable(_mockTurmas),
      selectedTab: state.selectedTab,
      selectedStudentId: state.selectedStudentId,
      selectedCourseId: state.selectedCourseId,
      selectedTurmaId: state.selectedTurmaId,
    );
  }

  // === Mock Data ===

  static final List<Course> _mockCourses = [
    Course(
      id: '1',
      name: 'Lógica de Programação',
      description: 'Aprenda os fundamentos de programação com exercícios práticos.',
    ),
    Course(
      id: '2',
      name: 'Flutter Básico',
      description: 'Construa seus primeiros apps com Flutter.',
    ),
    Course(
      id: '3',
      name: 'Python para Web',
      description: 'Desenvolvimento web com Python e Django.',
    ),
    Course(
      id: '4',
      name: 'Java 1',
      description: 'Introdução à programação orientada a objetos com Java.',
    ),
  ];

  static final List<Turma> _mockTurmas = [
    Turma(
      id: 't1',
      cursoId: '1',
      nome: 'Lógica de Programação - Junho/2026',
      mes: 6,
      ano: 2026,
      dataInicio: DateTime(2026, 6, 1),
      dataFim: DateTime(2026, 6, 30),
      status: TurmaStatus.ativa,
      professorIds: ['p1'],
      alunoIds: ['a1', 'a2', 'a3'],
    ),
    Turma(
      id: 't2',
      cursoId: '1',
      nome: 'Lógica de Programação - Julho/2026',
      mes: 7,
      ano: 2026,
      dataInicio: DateTime(2026, 7, 1),
      dataFim: DateTime(2026, 7, 31),
      status: TurmaStatus.planejada,
      professorIds: ['p2'],
      alunoIds: [],
    ),
    Turma(
      id: 't3',
      cursoId: '4',
      nome: 'Java 1 - Junho/2026',
      mes: 6,
      ano: 2026,
      dataInicio: DateTime(2026, 6, 1),
      dataFim: DateTime(2026, 6, 30),
      status: TurmaStatus.ativa,
      professorIds: ['p1', 'p2'],
      alunoIds: ['a1', 'a2'],
    ),
    Turma(
      id: 't4',
      cursoId: '2',
      nome: 'Flutter Básico - Agosto/2026',
      mes: 8,
      ano: 2026,
      dataInicio: DateTime(2026, 8, 1),
      dataFim: DateTime(2026, 8, 31),
      status: TurmaStatus.planejada,
      professorIds: [],
      alunoIds: [],
    ),
  ];
}

final adminViewModelProvider = NotifierProvider<AdminViewModel, AdminDashboardState>(() {
  return AdminViewModel();
});