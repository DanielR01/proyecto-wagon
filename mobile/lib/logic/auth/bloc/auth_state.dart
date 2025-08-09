part of 'auth_bloc.dart';

/// Posibles estados de autenticación de la aplicación.
enum AuthStatus { authenticated, unauthenticated, unknown }

/// Estado inmutable que representa la sesión actual del usuario.
class AuthState extends Equatable {
  /// Estado de autenticación actual.
  final AuthStatus status;

  /// Usuario autenticado cuando [status] es [AuthStatus.authenticated].
  final User? user;

  const AuthState._({this.status = AuthStatus.unknown, this.user});

  /// Estado inicial: aún no se sabe si hay sesión.
  const AuthState.unknown() : this._();

  /// Estado con usuario autenticado.
  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  /// Estado sin usuario autenticado.
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}