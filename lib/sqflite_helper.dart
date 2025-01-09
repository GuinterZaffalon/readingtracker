import 'package:path/path.dart';
import 'package:readingtracker/src/components/books.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteHelper {
  Future<Database> openMyDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'books.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE booksFinished(id INTEGER PRIMARY KEY, title TEXT, pages INTEGER, author TEXT, publisher TEXT, rating INTEGER, date TEXT, editionYear INTEGER, cover TEXT, comment TEXT)",
        );
        await db.execute(
          "CREATE TABLE booksReading(id INTEGER PRIMARY KEY, title TEXT, author TEXT, pages INTEGER, date TEXT)",
        );
      },
    );
  }

  Future<bool> titleExists(String table ,String title) async {
    final db = await openMyDatabase();
    final result = await db.query(
      table,
      where: 'title = ?',
      whereArgs: [title],
    );
    return result.isNotEmpty;
  }

  Future<void> insertBookFinished(Map<String, dynamic> book) async {
    final db = await openMyDatabase();
    final title = book['title'];
    if (await titleExists('booksFinished', title)) {
      print('O livro "$title" já existe na tabela booksFinished. Não será salvo.');
      return;
    }
    await db.insert(
      'booksFinished',
      book,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Livro "$title" salvo com sucesso na tabela booksFinished.');
  }

  Future<void> insertBookReading(Map<String, dynamic> book) async {
    final db = await openMyDatabase();
    final title = book['title'];
    if (await titleExists('booksReading', title)) {
      print('O livro "$title" já existe na tabela booksReading. Não será salvo.');
      return;
    }
    await db.insert(
      'booksReading',
      book,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Progresso salvo com sucesso do livro ${book['title']}.");
  }

  Future<List<Map<dynamic, dynamic>>> getBooksFinished() async {
    final db = await openMyDatabase();
    final result = await db.query('booksFinished');
    return result;
  }

  Future<List<Map<dynamic, dynamic>>> getBookById(int id) async{
    final db = await openMyDatabase();
    final result = await db.query(
      'booksFinished',
      whereArgs: [id],
    );
    return result;
  }

}