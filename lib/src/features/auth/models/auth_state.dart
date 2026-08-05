import '../../../core/models/user_model.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? userCpf;
  final AppUser? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userCpf,
    this.user,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        userCpf = null,
        user = null,
        errorMessage = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        userCpf = null,
        user = null,
        errorMessage = null;

  AuthState.success(AppUser user)
      : status = AuthStatus.success,
        userCpf = user.cpf,
        user = user,
        errorMessage = null;

  const AuthState.error(String message)
      : status = AuthStatus.error,
        userCpf = null,
        user = null,
        errorMessage = message;
}