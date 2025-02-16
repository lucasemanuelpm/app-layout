import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'planet.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  // Construtor privado para garantir o singleton
  DatabaseHelper._init();

  // Acesso ao banco de dados
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB();
      return _database!;
    }
  }

  // Inicializa o banco de dados
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'planets.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Criação da tabela
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE planets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
  }

  // Método para adicionar um planeta
  Future<int> addPlanet(Planet planet) async {
    final db = await database;
    return await db.insert('planets', planet.toMap());
  }

  // Método para atualizar um planeta
  Future<int> updatePlanet(Planet planet, int id) async {
    final db = await database;
    return await db.update(
      'planets',
      planet.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

