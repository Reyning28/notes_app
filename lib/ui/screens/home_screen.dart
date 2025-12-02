import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/ui/widgets/note_card.dart';
import 'note_from_screen.dart'; // Importa la pantalla de formulario.

// Pantalla principal que muestra la lista de notas.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Usa Future.microtask para asegurar que el 'context' está listo
    // y carga las notas inmediatamente después de la construcción inicial.
    Future.microtask(
          () => context.read<NoteProvider>().loadNotes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Notas'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // Usa Consumer para escuchar los cambios en NoteProvider.
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          // 1. Si está cargando, muestra un indicador de progreso.
          if (noteProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Si no hay notas, muestra un mensaje de "No hay notas".
          if (noteProvider.notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay notas',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toca el botón + para crear una',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          // 3. Si hay notas, muestra la lista.
          return ListView.builder(
            itemCount: noteProvider.notes.length,
            itemBuilder: (context, index) {
              final note = noteProvider.notes[index];
              return NoteCard( // Widget que representa cada nota en la lista.
                note: note,
                // Acción al tocar la tarjeta: navegar a NoteFormScreen para editar.
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteFormScreen(note: note),
                    ),
                  );
                },
                // Acción al eliminar: llama a deleteNote y muestra un SnackBar.
                onDelete: () {
                  noteProvider.deleteNote(note.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nota eliminada'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Botón flotante para crear una nueva nota.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega a NoteFormScreen sin pasar ninguna nota (creación).
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteFormScreen(),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}