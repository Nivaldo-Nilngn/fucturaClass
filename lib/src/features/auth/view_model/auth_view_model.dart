import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../../../core/models/user_model.dart';

class AuthViewModel extends Notifier<AuthState> {
  final List<AppUser> _users = [
    AppUser(
      id: '1',
      name: 'Admin Fuctura',
      cpf: '00000000000',
      role: UserRole.admin,
      createdAt: DateTime.now(),
    ),
    AppUser(
      id: '2',
      name: 'Rafael Souza',
      cpf: '11111111111',
      role: UserRole.student,
      createdAt: DateTime.now(),
    ),
    AppUser(
      id: '3',
      name: 'Prof. Carlos',
      cpf: '22222222222',
      role: UserRole.professor,
      createdAt: DateTime.now(),
    ),
    AppUser(
      id: '4',
      name: 'Secretaria',
      cpf: '33333333333',
      role: UserRole.secretary,
      createdAt: DateTime.now(),
    )
  ];

  List<AppUser> get users => List.unmodifiable(_users);

  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> login(String cpf, String password) async {
    state = const AuthState.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (cpf.isEmpty || password.isEmpty) {
        state = const AuthState.error('CPF e senha são obrigatórios.');
        return;
      }

      // Permite logar tanto pelo CPF formatado/limpo quanto pelo login
      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final user = _users.where((u) => u.cpf == cleanCpf).firstOrNull;

      if (user != null && password == '123456') {
        state = AuthState.success(user);
      } else {
        state = const AuthState.error('Credenciais inválidas.');
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void logout() {
    state = const AuthState.initial();
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});