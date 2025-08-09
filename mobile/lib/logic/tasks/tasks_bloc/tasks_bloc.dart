import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/api/tasks_repository.dart';
import 'package:mobile/models/task_model.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

/// BLoC que gestiona la lista de tareas, coordinando con el [TasksRepository].
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository _tasksRepository;

  /// Crea el BLoC y registra los manejadores de eventos.
  TasksBloc({required TasksRepository tasksRepository})
      : _tasksRepository = tasksRepository,
        super(TasksInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<AddDefaultTasks>(_onAddDefaultTasks); // Registra el manejador para añadir tareas por defecto.
  }

  /// Carga las tareas desde el repositorio y emite el resultado.
  void _onLoadTasks(LoadTasks event, Emitter<TasksState> emit) async {
    emit(TasksLoadInProgress());
    try {
      final tasks = await _tasksRepository.getTasks();
      emit(TasksLoadSuccess(tasks));
    } catch (e) {
      emit(TasksLoadFailure(e.toString()));
    }
  }

  /// Crea una nueva tarea y actualiza el estado con la lista resultante.
  void _onAddTask(AddTask event, Emitter<TasksState> emit) async {
    final currentState = state;
    if (currentState is TasksLoadSuccess) {
      try {
        final newTask = await _tasksRepository.createTask(
          title: event.title,
          description: event.description,
        );
        final updatedTasks = [newTask, ...currentState.tasks];
        emit(TasksLoadSuccess(updatedTasks));
      } catch (e) {
        emit(TasksLoadFailure(e.toString()));
        emit(TasksLoadSuccess(currentState.tasks));
      }
    }
  }

  /// Actualiza una tarea existente y reemplaza su entrada en la lista actual.
  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) async {
    final currentState = state;
    if (currentState is TasksLoadSuccess) {
      try {
        final updatedTask = await _tasksRepository.updateTask(event.task);
        final updatedTasks = currentState.tasks.map((task) {
          return task.id == updatedTask.id ? updatedTask : task;
        }).toList();
        emit(TasksLoadSuccess(updatedTasks));
      } catch (e) {
        emit(TasksLoadFailure(e.toString()));
        emit(TasksLoadSuccess(currentState.tasks));
      }
    }
  }

  /// Elimina una tarea y emite la lista sin el elemento borrado.
  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) async {
    final currentState = state;
    if (currentState is TasksLoadSuccess) {
      try {
        await _tasksRepository.deleteTask(event.taskId);
        final updatedTasks = currentState.tasks.where((task) => task.id != event.taskId).toList();
        emit(TasksLoadSuccess(updatedTasks));
      } catch (e) {
        emit(TasksLoadFailure(e.toString()));
        emit(TasksLoadSuccess(currentState.tasks));
      }
    }
  }

  /// Crea tres tareas por defecto para usuarios nuevos y recarga la lista.
  void _onAddDefaultTasks(AddDefaultTasks event, Emitter<TasksState> emit) async {
    try {
      emit(TasksLoadInProgress());
      await _tasksRepository.createTask(title: 'Reservar con Wagon para el fin de semana 🚀', description: 'Y contratar a Daniel Rojas Asis, jejeje');
      await _tasksRepository.createTask(title: 'Toca el botón (+) para añadir una nueva tarea', description: '');
      await _tasksRepository.createTask(title: 'Toca la tarea para editarla y la casilla para completarla', description: '');
       await _tasksRepository.createTask(
          title: 'Bienvenido al Gestor de Tareas Wagon!', description: 'Desliza hacia la izquierda para eliminarme.');

      // Tras crearlas, recarga la lista para mostrarlas en la UI.
      add(LoadTasks());
    } catch (e) {
      emit(TasksLoadFailure(e.toString()));
    }
  }
}
