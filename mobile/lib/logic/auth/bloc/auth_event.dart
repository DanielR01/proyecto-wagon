part of 'auth_bloc.dart';

/// Clase base para todos los eventos de autenticación.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Evento emitido cuando cambia el usuario autenticado (login/logout o actualización).
class AuthStateChanged extends AuthEvent {
  /// Usuario actual o `null` si no hay sesión iniciada.
  final User? user;
  const AuthStateChanged(this.user);
}

/// Solicita cerrar la sesión del usuario actual.
class AuthLogoutRequested extends AuthEvent {}
