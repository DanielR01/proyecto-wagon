import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/logic/auth/bloc/auth_bloc.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/tasks/tasks_list_screen.dart';

/// Puerta de autenticación para decidir qué pantalla mostrar según el estado.
///
/// - Autenticado: muestra [`TaskListScreen`]
/// - No autenticado: muestra [`LoginScreen`]
/// - Desconocido: muestra un loader hasta resolver el estado
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    /// Construye condicionalmente la UI a partir del estado del [AuthBloc].
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            // Si está autenticado, muestra la pantalla principal
            return const TaskListScreen();
          case AuthStatus.unauthenticated:
            // Si no, muestra la pantalla de login
            return const LoginScreen();
          case AuthStatus.unknown:
            // Mientras se determina el estado, muestra un loader
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
