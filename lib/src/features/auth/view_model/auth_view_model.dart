import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/app_user.dart';

class AuthViewModel extends Notifier<AuthState> {
  final List<AppUser> _users = [
    const AppUser(
      id: '1',
      name: 'Admin Fuctura',
      email: 'dev@fuctura.com',
      role: UserRole.admin,
    ),
    const AppUser(
      id: '2',
      name: 'Rafael Souza',
      email: 'aluno@fuctura.com',
      role: UserRole.aluno,
      turma: 'TURMA SÁBADO',
      modulo: 'Lógica de Programação',
    ),
    const AppUser(
      id: '3',
      name: 'Prof. Carlos',
      email: 'prof@fuctura.com',
      role: UserRole.professor,
      turma: 'TURMA SÁBADO',
    ),
  ];

  List<AppUser> get users => List.unmodifiable(_users);

  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (email.isEmpty || password.isEmpty) {
        state = const AuthState.error('E-mail e senha são obrigatórios.');
        return;
      }

      final user = _users.where((u) => u.email == email).firstOrNull;

      if (user != null && password == '123456') {
        state = AuthState.success(user);
      } else {
        state = const AuthState.error('E-mail ou senha inválidos.');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void registerUser({
    required String name,
    required String email,
    required UserRole role,
    String? turma,
    String? modulo,
  }) {
    final newUser = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      role: role,
      turma: turma,
      modulo: modulo,
    );
    _users.add(newUser);
  }

  void removeUser(String id) {
    _users.removeWhere((u) => u.id == id);
  }

  void logout() {
    state = const AuthState.initial();
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});