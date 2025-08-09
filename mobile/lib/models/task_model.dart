import 'package:equatable/equatable.dart';

/// Modelo de dominio que representa una tarea en la aplicación.
class Task extends Equatable {
  /// Identificador único de la tarea.
  final String id;

  /// Título de la tarea.
  final String title;

  /// Descripción de la tarea.
  final String description;

  /// Si la tarea está marcada como completada.
  final bool completed;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  /// Construye una instancia de [Task] a partir de un objeto JSON.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
    );
  }

  /// Devuelve una copia de esta tarea con los campos proporcionados actualizados.
  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object?> get props => [id, title, description, completed];
}
