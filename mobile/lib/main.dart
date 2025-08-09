// Archivo principal de la aplicación Wagon Tasks.
// Inicializa Firebase y configura los repositorios y BLoCs usados en toda la app.
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/tasks_repository.dart';
import 'package:mobile/logic/auth/auth_repository.dart';
import 'package:mobile/logic/auth/bloc/auth_bloc.dart';
import 'package:mobile/logic/tasks/tasks_bloc/tasks_bloc.dart';
import 'package:mobile/screens/auth/login_screen.dart';
import 'package:mobile/screens/tasks/tasks_list_screen.dart';
import 'firebase_options.dart';

/// Punto de entrada de la aplicación.
/// - Asegura la inicialización de Flutter.
/// - Inicializa Firebase con las opciones generadas.
/// - Ejecuta el widget raíz [`MyApp`].
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/// Widget raíz de la app que provee repositorios y BLoCs a través del árbol de widgets.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => TasksRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => TasksBloc(
              tasksRepository: context.read<TasksRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Gestor de Tareas Wagon',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const AuthGate(),
        ),
      ),
    );
  }
}

/// Puerta de autenticación.
/// Escucha cambios en el estado de autenticación y navega entre inicio de sesión
/// y la lista de tareas. Para usuarios nuevos, crea tareas por defecto.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Al autenticarse, decide entre crear tareas por defecto (usuarios nuevos)
        // o cargar las existentes (usuarios recurrentes).
        if (state.status == AuthStatus.authenticated) {
          final user = state.user!;
          if (user.metadata.creationTime == user.metadata.lastSignInTime) {
            context.read<TasksBloc>().add(AddDefaultTasks());
          } else {
            context.read<TasksBloc>().add(LoadTasks());
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            return const TaskListScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
