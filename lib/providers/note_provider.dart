import 'package:flutter/foundation.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/data/repositories/note_repository.dart';

// Gestiona el estado de las notas y notifica cambios a la UI
class NoteProvider with ChangeNotifier {
  final NoteRepository _repository = NoteRepository();
  List<Note> _notes = [];
  bool _isLoading = false;

  // Getters para acceder a los datos desde la UI
  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  // Carga todas las notas desde la base de datos
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners(); // Avisa a la UI que está cargando

    try {
      _notes = await _repository.getAllNotes();
    } catch (e) {
      debugPrint('Error al cargar notas: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Avisa a la UI que terminó de cargar
    }
  }

  // Crea una nueva nota y la agrega al inicio de la lista
  Future<void> addNote(Note note) async {
    try {
      final id = await _repository.createNote(note);
      final newNote = note.copyWith(id: id);
      _notes.insert(0, newNote); // Agrega al principio
      notifyListeners(); // Actualiza la UI
    } catch (e) {
      debugPrint('Error al crear nota: $e');
      rethrow; // Propaga el error para manejarlo en la UI
    }
  }

  // Actualiza una nota existente en la lista
  Future<void> updateNote(Note note) async {
    try {
      await _repository.updateNote(note);
      // Busca y reemplaza la nota en la lista
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        notifyListeners(); // Actualiza la UI
      }
    } catch (e) {
      debugPrint('Error al actualizar nota: $e');
      rethrow;
    }
  }

  // Elimina una nota de la lista
  Future<void> deleteNote(int id) async {
    try {
      await _repository.deleteNote(id);
      _notes.removeWhere((note) => note.id == id); // Quita de la lista
      notifyListeners(); // Actualiza la UI
    } catch (e) {
      debugPrint('Error al eliminar nota: $e');
      rethrow;
    }
  }
}