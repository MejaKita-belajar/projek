import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ItemService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'item_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, description TEXT, imageUrl TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> createItem(String name, String description, String imageUrl) async {
    final db = await database;
    await db.insert(
      'items',
      {'name': name, 'description': description, 'imageUrl': imageUrl},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Item {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  Item({required this.id, required this.name, required this.description, required this.imageUrl});
}
