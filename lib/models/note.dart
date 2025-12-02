class Note{
  final int? id;
  final String title;
  final String content;
  final DateTime date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
});

  //Aqui se convierte el map para SQLite
Map<String, dynamic> toMap() {
  return{
    'id': id,
    'title': title,
    'content': content,
    'date': date.toIso8601String(),
  };
}

factory Note.fromMap(Map<String, dynamic> map) {
  return Note(
    id: map['id'] as int?,
    title: map['title'] as String,
    content: map['content'] as String,
    date: DateTime.parse(map['date'] as String),
  );
}

Note copyWith({
  int? id,
  String? title,
  String? content,
  DateTime? date,
}) {
  return Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    date: date ?? this.date,
  );
}
}