import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id; // ID do documento no Firestore
  final String description;
  final String date;
  final String time;
  bool finished;

  Task({
    required this.id,
    required this.description,
    required this.date,
    required this.time,
    this.finished = false,
  });

  /// Factory constructor para criar uma instância de Task a partir de um DocumentSnapshot do Firestore.
  /// facilitando a conversão dos dados do banco para o objeto Dart.
  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      description: data['description'] ?? '', 
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      finished: data['finished'] ?? false,
    );
  }
}