import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'planet.dart'; // Importando a classe Planet

class DatabaseHelper {
  static Database? _database;

  // Inicializa o banco de dados
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB();
      return _database!;
    }
  }

  // Cria o banco de dados e a tabela
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'planets.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Criação da tabela no banco
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
  }

  // Método para adicionar um planeta no banco
  Future<int> addPlanet(Planet planet) async {
    final db = await database;
    return await db.insert('planets', planet.toMap());
  }
}
