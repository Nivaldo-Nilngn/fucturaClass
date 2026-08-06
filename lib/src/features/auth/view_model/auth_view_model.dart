import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../services/firebase_auth_service.dart';
import '../../../core/models/user_model.dart';

final firebaseAuthServiceProvider = Provider((ref) => FirebaseAuthService());

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> login(String cpf, String password) async {
    state = const AuthState.loading();
    try {
      if (cpf.isEmpty || password.isEmpty) {
        state = const AuthState.error('CPF e senha são obrigatórios.');
        return;
      }

      final authService = ref.read(firebaseAuthServiceProvider);
      final user = await authService.loginWithCpf(cpf, password);

      if (user != null) {
        state = AuthState.success(user);
      } else {
        state = const AuthState.error('Credenciais inválidas ou usuário não encontrado.');
      }
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> register(String name, String cpf, String password, {String? academyId}) async {
    state = const AuthState.loading();
    try {
      if (name.isEmpty || cpf.isEmpty || password.isEmpty) {
        state = const AuthState.error('Todos os campos são obrigatórios.');
        return;
      }

      final authService = ref.read(firebaseAuthServiceProvider);
      final user = await authService.registerWithCpf(name, cpf, password, academyId: academyId);

      if (user != null) {
        state = AuthState.success(user);
      } else {
        state = const AuthState.error('Falha desconhecida ao cadastrar.');
      }
    } catch (e) {
      state = AuthState.error(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(firebaseAuthServiceProvider).logout();
    } finally {
      state = const AuthState.initial();
    }
  }

  void updateUserLocally(AppUser updatedUser) {
    state = AuthState.success(updatedUser);
  }
}

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});