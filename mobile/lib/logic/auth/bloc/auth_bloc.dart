import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/logic/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC responsable de transformar los eventos de autenticación en estados de UI.
///
/// Se suscribe al stream de [`AuthRepository.authStateChanges`] para reflejar
/// automáticamente cambios de sesión en la aplicación.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  /// Inicializa el BLoC y comienza a escuchar cambios de autenticación.
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.unknown()) {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthStateChanged(user));
    });

    on<AuthStateChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthState.authenticated(event.user!));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });

    on<AuthLogoutRequested>((event, emit) {
      _authRepository.signOut();
    });
  }

  /// Cancela suscripciones internas al cerrar el BLoC.
  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
