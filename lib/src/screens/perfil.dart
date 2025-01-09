import 'package:flutter/material.dart';
import 'package:readingtracker/src/components/books.dart';
import '../../sqflite_helper.dart';

class perfilPage extends StatefulWidget {
  const perfilPage({Key? key}) : super(key: key);

  @override
  State<perfilPage> createState() => _perfilPageState();
}

class BookData implements BooksInterface {
  @override
  String? title;
  @override
  String? author;
  @override
  String? publisher;
  @override
  int? editionYear;
  @override
  String? cover;
  @override
  int? rating;
  @override
  String? date;
  @override
  String? comment;

  BookData({
    this.title,
    this.author,
    this.publisher,
    this.editionYear,
    this.cover,
    this.rating,
    this.date,
    this.comment,
  });
}


class _perfilPageState extends State<perfilPage> {
  final sqfliteHelper = SqfliteHelper();
  late List<BooksInterface> books = [];

  Future<List<BooksInterface>> getBooksFinished() async {
    final result = await sqfliteHelper.getBooksFinished();
    return result.map((book) {
      return BookData(
        title: book['title']?.toString(),
        author: book['author']?.toString(),
        publisher: book['publisher']?.toString(),
        rating: int.tryParse(book['rating']?.toString() ?? '') ?? 0,
        date: book['date']?.toString(),
        editionYear: int.tryParse(book['editionYear']?.toString() ?? '') ?? 0,
        cover: book['cover']?.toString(),
        comment: book['comment']?.toString(),
      );
    }).toList();
  }


  Future<void> saveBooksFinished() async {
      final fetchedBooks = await getBooksFinished();
      setState(() {
        books = fetchedBooks;
      });
    }

  void initState() {
    super.initState();
    getBooksFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
        title: const Text("ReadingTracker"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 10, 0),
            child: Text("Suas leituras!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: books.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Books(book: books[index]),
              );
            },
          ),

        ],
      ),
    );
  }
}
