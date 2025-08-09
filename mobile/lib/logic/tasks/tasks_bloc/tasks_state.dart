part of 'tasks_bloc.dart';

/// Clase base de estados para la pantalla de tareas.
abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

/// Estado inicial antes de cargar datos.
class TasksInitial extends TasksState {}

/// Estado de carga mientras se consultan las tareas.
class TasksLoadInProgress extends TasksState {}

/// Estado exitoso con la lista de tareas actual.
class TasksLoadSuccess extends TasksState {
  final List<Task> tasks;
  const TasksLoadSuccess([this.tasks = const []]);

  @override
  List<Object> get props => [tasks];
}

/// Estado de error con un mensaje descriptivo.
class TasksLoadFailure extends TasksState {
  final String error;

  const TasksLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
