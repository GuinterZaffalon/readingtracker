import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteHelper {
  Future<Database> openMyDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'books.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE booksFinished(id INTEGER PRIMARY KEY, title TEXT, author TEXT, pages INTEGER, rating INTEGER, date TEXT)"
          "CREATE TABLE booksReading(id INTEGER PRIMARY KEY, title TEXT, author TEXT, pages INTEGER, date TEXT)",
        );
      },
    );
  }

  Future<void> insertBookFinished(Map<String, dynamic> book) async {
    final db = await openMyDatabase();
    await db.insert(
      'booksFinished',
      book,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBookReading(Map<String, dynamic> book) async {
    final db = await openMyDatabase();
    await db.insert(
      'booksReading',
      book,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}