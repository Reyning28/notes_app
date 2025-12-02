import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'ui/screens/home_screen.dart';


// Función principal que inicia la aplicación.
void main() {
  runApp(const MyApp());
}

// Widget principal sin estado que define la estructura de la aplicación.
class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Usa ChangeNotifierProvider para hacer NoteProvider accesible globalmente.
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(), // Crea una instancia de NoteProvider.
      child: MaterialApp(
        title: 'Notes App',
        debugShowCheckedModeBanner: false, // Oculta el banner de "Debug".
        theme: ThemeData(
          // Define el tema principal (color morado) y usa Material 3.
            primarySwatch: Colors.deepPurple,
            useMaterial3: true
        ),
        // Define HomeScreen como la pantalla inicial.
        home: const HomeScreen(),
      ),
    );
  }
} // Fin de la clase MyApp.