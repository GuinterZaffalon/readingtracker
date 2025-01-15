import 'package:flutter/material.dart';
import 'package:readingtracker/src/model/sqflite_helper.dart';
import '../components/books.dart';
import '../components/listItems.dart';

class ListItemsObject implements ListItemsInterface {
  @override
  late String title;
  late int id;

  ListItemsObject(this.title, this.id);
}

class BookData implements BooksInterface {
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

class Expandedlist extends StatefulWidget {
  final ListItemsInterface title;
  final ListItemsInterface id;
  const Expandedlist({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  State<Expandedlist> createState() => _ExpandedlistState();
}

class _ExpandedlistState extends State<Expandedlist> {
  SqfliteHelper sqfliteHelper = SqfliteHelper();
  List<BooksInterface> books = [];
  List<BooksInterface> bookConsulting = [];

  Future<List<BooksInterface>> getBooksList(int listId) async {
    final books = await sqfliteHelper.getBooksOfList(listId);
    return books.map((book) {
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

  Future<void> saveBooksList() async {
    final fetchedBooks = await getBooksList(widget.id.id);
    setState(() {
      books = fetchedBooks;
    });
  }

  Future<List<BooksInterface>> getBooks() async {
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
      books = fetchedBooks;
    });
  }

  void initState() {
    super.initState();
    saveBooksList();
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
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(children: [
              Text(
                widget.title.title,
                style: const TextStyle(
                    fontSize: 30,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.add_rounded),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () {}),
                ],
              )
            ])),

      ])),
    );
  }
}
