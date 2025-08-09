import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/logic/auth/auth_repository.dart';

/// Pantalla de autenticación con formulario para iniciar sesión o registrarse.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  /// Mapea códigos de error de Firebase a mensajes amigables en inglés.
  /// Puedes adaptar estos mensajes al español según necesites.
  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email o contraseña inválidos. Por favor, inténtelo de nuevo.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese email.';
      case 'weak-password':
        return 'La contraseña proporcionada es demasiado débil.';
      default:
        return 'Ocurrió un error inesperado. Por favor, inténtelo de nuevo.';
    }
  }

  /// Ejecuta una acción de autenticación mostrando un loader y gestionando errores.
  void _handleAuthAction(Future<void> Function() authAction) async {
    setState(() => _isLoading = true);
    try {
      await authAction();
      // La navegación la maneja el AuthBloc en auth_gate.dart
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        final errorMessage = _getErrorMessage(e.code);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de Tareas Wagon'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton(
                onPressed: () => _handleAuthAction(() => _authRepository.signIn(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    )),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _handleAuthAction(() => _authRepository.signUp(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    )),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Registrarse'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
