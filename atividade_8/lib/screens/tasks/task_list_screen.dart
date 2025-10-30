import 'package:flutter/material.dart';
import '../../model/task_model.dart';
import '../../services/firestore_service.dart'; 

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informação'),
          content: const Text('Você está no App de Notas de Tarefas.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas (Firestore)'),
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<List<Task>>(
        stream: _firestoreService.getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada.'));
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Checkbox(
                    value: task.finished,
                    onChanged: (bool? value) {
                      if (value != null) {
                        _firestoreService.updateTaskStatus(task.id, value);
                      }
                    },
                  ),
                  title: Text(
                    task.description,
                    style: TextStyle(
                      decoration: task.finished
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: task.finished ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text('${task.date} - ${task.time}'),
                  trailing: const Icon(Icons.drag_handle),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInfoDialog,
        tooltip: 'Informação',
        backgroundColor: Colors.purple,
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}