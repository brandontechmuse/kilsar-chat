import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String text;

  const Task({required this.id, required this.text});

  @override
  List<Object?> get props => [id, text];

  Task copyWith({String? id, String? text}) =>
      Task(id: id ?? this.id, text: text ?? this.text);

  Map<String, dynamic> toJson() => {'id': id, 'text': text};
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'] as String, text: json['text'] as String);
}
