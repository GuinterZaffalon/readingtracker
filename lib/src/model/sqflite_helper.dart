import 'package:path/path.dart';
import 'package:readingtracker/src/components/books.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteHelper {
  Future<Database> openMyDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'books.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE booksFinished(id INTEGER PRIMARY KEY, title TEXT, pages INTEGER, author TEXT, publisher TEXT, rating INTEGER, date TEXT, editionYear INTEGER, cover TEXT, comment TEXT)",
        );
        await db.execute(
          "CREATE TABLE booksReading(id INTEGER PRIMARY KEY, title TEXT, author TEXT, pages INTEGER, date TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "CREATE TABLE userList(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, bookID INTEGER, FOREIGN KEY(bookID) REFERENCES booksFinished(id))",
          );
        }
      },
    );
  }

  Future<bool> titleExists(String table, String title) async {
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
      print(
          'O livro "$title" já existe na tabela booksFinished. Não será salvo.');
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
      print(
          'O livro "$title" já existe na tabela booksReading. Não será salvo.');
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

  Future<List<Map<dynamic, dynamic>>> getBookById(int id) async {
    final db = await openMyDatabase();
    final result = await db.query(
      'booksFinished',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<void> deleteBookById(int id) async => await openMyDatabase().then(
      (db) => db.delete('booksFinished', where: 'id = ?', whereArgs: [id]).then(
          (value) => print('Livro deletado com sucesso.')));

  Future<List<Map<dynamic, dynamic>>> getBooksByDate(String dateInitial, String dateFinal) async {
    final db = await openMyDatabase();
    final result = await db.query(
      'booksFinished',
      where: 'date = ?',
      whereArgs: [dateInitial, dateFinal],
    );
    return result;
  }

  Future<void> createBookList (String name) async {
    final db = await openMyDatabase();
    await db.insert(
      'userList',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBookInList (int bookID, String name) async {
    final db = await openMyDatabase();
    await db.insert(
      'userList',
      {'bookID': bookID, 'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<dynamic, dynamic>>> getUserList() async {
    final db = await openMyDatabase();
    final result = await db.query(
      'userList',
    );
    return result;
  }
}
