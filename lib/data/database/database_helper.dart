import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notes_app/models/note.dart';

// Clase para manejar todas las operaciones de la base de datos
class DatabaseHelper {
  // Patrón Singleton: una sola instancia en toda la app
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Constructor privado para el Singleton
  DatabaseHelper._init();

  // Obtiene la base de datos, la crea si no existe
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // Inicializa la base de datos en el dispositivo
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crea la tabla 'notes' con sus columnas
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        title $textType,
        content $textType,
        date $textType
      )
    ''');
  }

  // Guarda una nueva nota en la base de datos
  Future<int> create(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  // Lee una nota específica por su ID
  Future<Note?> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromMap(maps.first);
    }
    return null;
  }

  // Obtiene todas las notas ordenadas por fecha (más recientes primero)
  Future<List<Note>> readAll() async {
    final db = await instance.database;
    const orderBy = 'date DESC';
    final result = await db.query('notes', orderBy: orderBy);
    return result.map((json) => Note.fromMap(json)).toList();
  }

  // Actualiza una nota existente
  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Elimina una nota por su ID
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Cierra la conexión a la base de datos
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}