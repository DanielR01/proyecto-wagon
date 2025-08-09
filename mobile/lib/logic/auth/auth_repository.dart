import 'package:firebase_auth/firebase_auth.dart';

/// Repositorio de autenticación que envuelve la API de FirebaseAuth.
///
/// Expone un stream con los cambios de sesión y métodos para iniciar sesión,
/// registrar usuarios y cerrar sesión.
class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  /// Permite inyectar una instancia de [FirebaseAuth] (útil para tests).
  AuthRepository({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Stream que emite el usuario actual o `null` cuando cambia el estado de autenticación.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Inicia sesión con email y contraseña.
  ///
  /// Propaga [FirebaseAuthException] para que la capa superior decida cómo manejarla.
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow; // Dejar que el BLoC maneje la excepción específica.
    }
  }

  /// Registra un nuevo usuario con email y contraseña.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  /// Cierra la sesión del usuario actual.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
