import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gallery.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const isFav = 'BOOLEAN';

    await db.execute('''
    CREATE TABLE photos (
      id $idType,
      filePath $textType,
      isFav $isFav
    )
    ''');
  }

    Future<void> saveProfile(Map<String, dynamic> profile) async {
    final db = await database;
    await db.insert(
      'profile',
      profile,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Ambil profil
  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('profile', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> insertPhoto(String filePath) async {
    final db = await instance.database;
    return await db.insert('photos', {'filePath': filePath, 'isFav': false});
  }

  Future<List<Map<String, dynamic>>> getAllPhotos() async {
    final db = await instance.database;
    return await db.query('photos');
  }

  Future<List<Map<String, dynamic>>> getFavPhotos() async {
    final db = await instance.database;
    return await db.query('photos', where: 'isFav = ?', whereArgs: [true]);
  }

  Future<int> deletePhoto(int id) async {
    final db = await instance.database;
    return await db.delete('photos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createAlbum(String name) async {
    final db = await instance.database;
    return await db.insert('albums', {'name': name});
  }

  Future<int> setFav(int id, bool isFav) async {
    final db = await instance.database;
    return await db.update('photos', {'isFav': !isFav}, where: 'id = ?', whereArgs: [id]);
  }
}
