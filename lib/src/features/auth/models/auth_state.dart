import 'app_user.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? userEmail;
  final AppUser? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userEmail,
    this.user,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        userEmail = null,
        user = null,
        errorMessage = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        userEmail = null,
        user = null,
        errorMessage = null;

  AuthState.success(AppUser user)
      : status = AuthStatus.success,
        userEmail = user.email,
        user = user,
        errorMessage = null;

  const AuthState.error(String message)
      : status = AuthStatus.error,
        userEmail = null,
        user = null,
        errorMessage = message;
}