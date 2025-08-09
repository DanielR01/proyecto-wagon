part of 'tasks_bloc.dart';

/// Clase base para todos los eventos de tareas.
abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

/// Solicita cargar la lista de tareas desde el repositorio.
class LoadTasks extends TasksEvent {}

/// Solicita crear una nueva tarea.
class AddTask extends TasksEvent {
  /// Título de la nueva tarea.
  final String title;

  /// Descripción de la nueva tarea.
  final String description;

  const AddTask({required this.title, required this.description});

  @override
  List<Object> get props => [title, description];
}

/// Solicita actualizar una tarea existente.
class UpdateTask extends TasksEvent {
  /// Tarea con los cambios a aplicar.
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

/// Solicita eliminar una tarea por su identificador.
class DeleteTask extends TasksEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object> get props => [taskId];
}

/// Solicita crear un conjunto de tareas por defecto para usuarios nuevos.
class AddDefaultTasks extends TasksEvent {}
