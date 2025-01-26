import 'package:flutter/material.dart';

import '../components/booksList.dart';
import '../components/listItems.dart';
import '../model/sqflite_helper.dart';

class ListItemsObject implements ListItemsInterface {
  @override
  late String title;
  late int id;

  ListItemsObject(this.title, this.id);
}

class BookData implements BooksListInterface {
  @override
  int? id;
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
    this.id,
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

class InsertBooksList extends StatefulWidget {
  final ListItemsInterface id;
  const InsertBooksList({Key? key, required this.id}) : super(key: key);

  @override
  State<InsertBooksList> createState() => _InsertBooksListState();
}

class _InsertBooksListState extends State<InsertBooksList> {
  List<BooksListInterface> bookConsulting = [];
  SqfliteHelper sqfliteHelper = SqfliteHelper();

  Future<List<BooksListInterface>> getBooks() async {
    final result = await sqfliteHelper.getBooksFinished();
    return result.map((book) {
      return BookData(
        id: book['id'],
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
    final fetchedBooks = await getBooks();
    setState(() {
      bookConsulting = fetchedBooks;
    });
  }

  void initState() {
    super.initState();
    saveBooksFinished();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
        title: const Text("ReadingTracker"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                "Selecione para adicionar!",
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 1 * MediaQuery.of(context).size.height,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: bookConsulting.length,
                  itemBuilder: (context, index) {
                    return BooksList(
                      book: bookConsulting[index],
                      id: widget.id,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
