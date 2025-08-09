import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/logic/tasks/tasks_bloc/tasks_bloc.dart';
import 'package:mobile/models/task_model.dart';

/// Pantalla para crear o editar una tarea.
///
/// Si se proporciona una [`Task`] en `task`, se inicializa en modo edición.
/// En caso contrario, funciona en modo creación.
class TaskEditScreen extends StatefulWidget {
  /// Tarea opcional. Si es `null`, la pantalla está en modo "Agregar".
  final Task? task;

  const TaskEditScreen({super.key, this.task});

  @override
  State<TaskEditScreen> createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  /// Devuelve `true` si la pantalla está en modo edición.
  bool get _isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    // Precarga los controladores si estamos en modo edición.
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController = TextEditingController(text: widget.task?.description);
  }

  /// Valida el formulario y despacha el evento correspondiente al BLoC.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_isEditMode) {
        // Envía un evento de actualización
        context.read<TasksBloc>().add(
              UpdateTask(
                widget.task!.copyWith(
                  title: _titleController.text,
                  description: _descriptionController.text,
                ),
              ),
            );
      } else {
        // Envía un evento de creación
        context.read<TasksBloc>().add(
              AddTask(
                title: _titleController.text,
                description: _descriptionController.text,
              ),
            );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Cambia el título según el modo
        title: Text(_isEditMode ? 'Editar Tarea' : 'Agregar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, ingrese un título.';
                  }
                  if (value.trim().length < 3) {
                    return 'El título debe tener al menos 3 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Guardar Tarea'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
