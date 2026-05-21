import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DatabaseProvider {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "eleve.db");

    return await openDatabase(
      path,
      version: 2, // 🔥 important pour activer la migration
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE eleve (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT,
            email TEXT,
            score INTEGER DEFAULT 0
          )
        """);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE eleve ADD COLUMN score INTEGER DEFAULT 0");
        }
      },
    );
  }

  // ------------------------------------------------------------
  // INSERT USER
  // ------------------------------------------------------------
  Future<int> insert(User user) async {
    final db = await database;
    return await db.insert("eleve", user.toMap());
  }

  // ------------------------------------------------------------
  // UPDATE SCORE
  // ------------------------------------------------------------
  Future<void> updateScore(int id, int newScore) async {
    final db = await database;
    await db.update(
      "eleve",
      {"score": newScore},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // ------------------------------------------------------------
  // GET ALL USERS
  // ------------------------------------------------------------
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final res = await db.query("eleve");

    return res.map((e) => User.fromMap(e)).toList();
  }
}
