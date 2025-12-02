import 'package:notes_app/models/note.dart';
import 'package:notes_app/data/database/database_helper.dart';

// Capa intermedia entre la UI y la base de datos
// Simplifica el acceso a los datos desde otras partes de la app
class NoteRepository{
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Obtiene todas las notas guardadas
  Future<List<Note>> getAllNotes() async{
    return await _databaseHelper.readAll();
  }

  // Busca una nota específica por su ID
  Future<Note?> getNoteById(int id) async{
    return await _databaseHelper.read(id);
  }

  // Crea y guarda una nueva nota
  Future<int> createNote(Note note) async{
    return await _databaseHelper.create(note);
  }

  // Actualiza una nota existente
  Future<int> updateNote(Note note) async{
    return await _databaseHelper.update(note);
  }

  // Elimina una nota por su ID
  Future<int> deleteNote(int id) async{
    return await _databaseHelper.delete(id);
  }
}