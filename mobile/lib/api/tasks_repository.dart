import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/models/task_model.dart';

/// Repositorio responsable de comunicarse con la API de tareas protegida por Firebase.
///
/// Expone operaciones CRUD sobre [`Task`], adjuntando el token de Firebase
/// en la cabecera `Authorization` para autenticar cada petición.
class TasksRepository {
  final String _baseUrl = "https://wagon-tasks-api.onrender.com";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Construye las cabeceras HTTP necesarias para autenticar la petición.
  ///
  /// Incluye `Content-Type: application/json` y `Authorization: Bearer <token>`.
  /// Lanza una excepción si no hay usuario autenticado.
  Future<Map<String, String>> _getHeaders() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    final token = await user.getIdToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Obtiene la lista de tareas del usuario autenticado.
  ///
  /// Devuelve una lista de [`Task`]. Lanza excepción si la respuesta no es 200.
  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tasks'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks. Status code: ${response.statusCode}');
    }
  }

  /// Crea una nueva tarea con `title` y `description`.
  ///
  /// Devuelve la tarea creada (201) o lanza excepción si falla.
  Future<Task> createTask({required String title, required String description}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/tasks'),
      headers: await _getHeaders(),
      body: json.encode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task. Status code: ${response.statusCode}');
    }
  }

  /// Actualiza una tarea existente identifieda por `task.id`.
  ///
  /// Devuelve la tarea actualizada (200) o lanza excepción si falla.
  Future<Task> updateTask(Task task) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/tasks/${task.id}'),
      headers: await _getHeaders(),
      body: json.encode({
        'title': task.title,
        'description': task.description,
        'completed': task.completed,
      }),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task. Status code: ${response.statusCode}');
    }
  }

  /// Elimina una tarea por su `taskId`.
  ///
  /// Lanza excepción si la respuesta no es 200.
  Future<void> deleteTask(String taskId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/tasks/$taskId'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task. Status code: ${response.statusCode}');
    }
  }
}
