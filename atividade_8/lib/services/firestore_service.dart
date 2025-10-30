import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/task_model.dart'; 

class FirestoreService {
  // Coleção de Tarefas
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
  
  // Coleção de Envios de Formulário
  final CollectionReference _formsCollection =
      FirebaseFirestore.instance.collection('form_submissions');

  Stream<List<Task>> getTasksStream() {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> updateTaskStatus(String taskId, bool isFinished) {
    return _tasksCollection.doc(taskId).update({'finished': isFinished});
  }

  Future<void> saveFormData({
    required String name,
    required String email,
    required String age,
    required String country,
  }) async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("Usuário não autenticado.");
      }

      await _formsCollection.add({
        'user_id': userId,
        'name': name,
        'email': email,
        'age': int.tryParse(age) ?? 0,
        'country': country,
        'submitted_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Erro ao salvar dados do formulário: $e");
      rethrow;
    }
  }
}