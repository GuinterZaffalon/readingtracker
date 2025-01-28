import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteHelper {

  Future<Database> openMyDatabase() async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'books.db'),
      version: 13,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE booksFinished(id INTEGER PRIMARY KEY, title TEXT, pages INTEGER, author TEXT, publisher TEXT, rating INTEGER, date TEXT, editionYear INTEGER, cover TEXT, comment TEXT)",
        );
        await db.execute(
          "CREATE TABLE userList(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)",
        );
        await db.execute(
          "CREATE TABLE listBooks(listId INTEGER, bookId INTEGER, PRIMARY KEY(listId, bookId), FOREIGN KEY(listId) REFERENCES lists(id), FOREIGN KEY(bookId) REFERENCES booksFinished(id))",
        );
        await db.execute(
          "CREATE TABLE booksReading(id INTEGER PRIMARY KEY, title TEXT, author TEXT)",
        );
        await db.execute(
          "CREATE TABLE bookReadingList(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, author TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 13) {
          await db.execute(
            "CREATE TABLE IF NOT EXISTS listBooks(listId INTEGER, bookId INTEGER, PRIMARY KEY(listId, bookId), FOREIGN KEY(listId) REFERENCES userList(id), FOREIGN KEY(bookId) REFERENCES booksFinished(id))",
          );
        }
      },
    );
    return db;
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

  Future<void> insertBookInList(int listId, int bookId) async {
    final db = await openMyDatabase();
    final result = await db.query('listBooks',
        where: 'listId = ? AND bookId = ?',
        whereArgs: [listId, bookId]);

    if (result.isEmpty) {
      await db.insert(
        'listBooks',
        {'listId': listId, 'bookId': bookId},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<void> insertReadingBookInList(int listId, String name, String author) async {
    final db = await openMyDatabase();

    final validateBookExists = await db.query(
      'bookReadingList',
      where: 'name = ? AND author = ?',
      whereArgs: [name, author],
    );

    int? bookId;
    if (validateBookExists.isNotEmpty) {
      bookId = validateBookExists[0]['id'] as int;
    }

    // Verifica se o livro já está na lista
    final validateIdExists = await db.query(
      'listBooks',
      where: 'listId = ? AND bookId = ?',
      whereArgs: [listId, bookId],
    );

    // Se o livro não existe na tabela bookReadingList e não está na lista, insere
    if (validateBookExists.isEmpty && (bookId == null || validateIdExists.isEmpty)) {
      final newBookId = await db.insert(
        'bookReadingList',
        {'name': name, 'author': author},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      await db.insert(
        'listBooks',
        {'listId': listId, 'bookReadingListId': newBookId},
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }



  Future<List<Map<String, dynamic>>> getBooksOfList(int listId) async {
    final db = await openMyDatabase();

    return await db.rawQuery(
      '''
    SELECT booksFinished.*
    FROM booksFinished
    INNER JOIN listBooks ON booksFinished.id = listBooks.bookId
    WHERE listBooks.listId = ?
    ''',
      [listId],
    );
  }




  Future<List<Map<dynamic, dynamic>>> getUserList() async {
    final db = await openMyDatabase();
    final result = await db.query(
      'userList',
    );
    return result;
  }

  Future<void> clearTable(String tableName) async {
    final db = await openMyDatabase();
    await db.delete(tableName);
  }
  // Future<List<Map<String, dynamic>>> getBooksOfList(int listId) async {
  //   final db = await openMyDatabase();
  //   final result = await db.rawQuery('''
  //   SELECT booksFinished.*
  //   FROM userList
  //   INNER JOIN booksFinished ON userList.bookID = booksFinished.id
  //   WHERE userList.id = ?
  // ''', [listId]);
  //   return result;
  // }
}
