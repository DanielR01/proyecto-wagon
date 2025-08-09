import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/logic/auth/bloc/auth_bloc.dart';
import 'package:mobile/logic/tasks/tasks_bloc/tasks_bloc.dart';
import 'package:mobile/screens/tasks/edit_task.dart';

/// Pantalla principal que lista las tareas del usuario.
///
/// Permite refrescar, crear, editar, completar y eliminar tareas.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Cerrar Sesión'),
                    content: const Text('¿Estás seguro de querer cerrar sesión?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Cerrar Sesión'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is TasksLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TasksLoadSuccess) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tienes tareas todavía!'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TasksBloc>().add(LoadTasks());
              },
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return Dismissible(
                    key: Key(task.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      context.read<TasksBloc>().add(DeleteTask(task.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${task.title} eliminada')),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<TasksBloc>(),
                              child: TaskEditScreen(task: task),
                            ),
                          ),
                        );
                      },
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(task.description),
                      leading: Checkbox(
                        value: task.completed,
                        onChanged: (value) {
                          context.read<TasksBloc>().add(
                                UpdateTask(
                                  task.copyWith(completed: value),
                                ),
                              );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
          if (state is TasksLoadFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error al cargar las tareas:\n\n${state.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          return const Center(child: Text('Algo salió mal.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TasksBloc>(),
                child: const TaskEditScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
