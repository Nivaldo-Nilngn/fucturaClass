enum UserRole { admin, professor, aluno }

class AppUser {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? turma;
  final String? modulo;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.turma,
    this.modulo,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isProfessor => role == UserRole.professor;
  bool get isAluno => role == UserRole.aluno;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? turma,
    String? modulo,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      turma: turma ?? this.turma,
      modulo: modulo ?? this.modulo,
    );
  }
}