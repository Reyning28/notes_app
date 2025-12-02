import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/note_provider.dart';


// Pantalla para crear o editar una nota. Recibe una 'Note' opcional.
class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  // Clave para el formulario, para validar los campos.
  final _formKey = GlobalKey<FormState>();
  // Controladores para los campos de texto 'título' y 'contenido'.
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  // Bandera para saber si estamos editando una nota existente.
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Inicializa _isEditing y los controladores con la nota si existe.
    _isEditing = widget.note != null;
    _titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores al destruir el widget.
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Función para guardar o actualizar la nota.
  Future<void> _saveNote() async {
    // Valida si el formulario es válido (campos no vacíos).
    if (_formKey.currentState!.validate()) {
      // Obtiene el NoteProvider usando 'context.read'.
      final noteProvider = context.read<NoteProvider>();

      // Crea un objeto Note con los datos de los controladores.
      final note = Note(
        id: widget.note?.id, // Mantiene el ID si es una edición.
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        date: DateTime.now(),
      );

      try {
        if (_isEditing) {
          // Si edita, llama a updateNote y muestra SnackBar.
          await noteProvider.updateNote(note);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nota actualizada')),
            );
          }
        } else {
          // Si es nueva, llama a addNote y muestra SnackBar.
          await noteProvider.addNote(note);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nota creada')),
            );
          }
        }
        // Navega de regreso a la pantalla anterior.
        if (mounted) Navigator.pop(context);
      } catch (e) {
        // Muestra un SnackBar si ocurre un error.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título dinámico: 'Editar Nota' o 'Nueva Nota'.
        title: Text(_isEditing ? 'Editar Nota' : 'Nueva Nota'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Botón para guardar/actualizar la nota.
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Form(
        key: _formKey, // Asigna la clave al formulario.
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo de texto para el título.
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              // Validador que verifica que el campo no esté vacío.
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa un título';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            // Campo de texto para el contenido.
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Contenido',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes),
              ),
              // Validador que verifica que el campo no esté vacío.
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa el contenido';
                }
                return null;
              },
              maxLines: 15, // Permite múltiples líneas de texto.
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}