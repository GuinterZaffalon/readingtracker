import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readingtracker/src/components/bookReading.dart';
import 'package:readingtracker/src/components/booksList.dart';
import 'package:readingtracker/src/model/sqflite_helper.dart';
import 'package:readingtracker/src/screens/insertBooksList.dart';
import 'package:readingtracker/src/screens/manualRegisterList.dart';
import '../components/books.dart';
import '../components/comment.dart';
import '../components/listItems.dart';
import 'list.dart';

class ListItemsObject implements ListItemsInterface {
  @override
  late String title;
  late int id;

  ListItemsObject(this.title, this.id);
}

class BookData implements BooksInterface, BooksListInterface {
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

class BookReadingObject implements BookReadingInterface {
  @override
  late String name;
  late String author;

  BookReadingObject(this.name, this.author);
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
  List<BookReadingInterface> booksReading = [];
  String title = '';
  String author = '';
  String newTitle = '';

  Future<List<BookData>> getBooksList(int listId) async {
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

  Future<List<BookReadingObject>> getBooksReading(int listId) async {
    final books = await sqfliteHelper.getBooksReadingOfList(listId);
    return books.map((book) {
      return BookReadingObject(
          book['name'].toString(), book['author'].toString());
    }).toList();
  }

  Future<void> editList(int listId, String name) async {
    await sqfliteHelper.editListName(listId, name);
  }

  Future<void> deleteList(int listId) async {
    await sqfliteHelper.deleteList(listId);
  }

  Future<void> saveBooksList() async {
    final fetchedBooksFinished = await getBooksList(widget.id.id);
    final fetchBooksReading = await getBooksReading(widget.id.id);
    setState(() {
      books = fetchedBooksFinished;
      booksReading = fetchBooksReading;
    });
  }

  void initState() {
    super.initState();
    saveBooksList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(149,203,226, 1),
            title: Text(
              widget.title.title,
              style: GoogleFonts.dmSans(textStyle: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.normal)),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                iconSize: 25,
                color: Colors.black,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => SizedBox(
                            height: 160,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                              Text(
                                  "Terminou o livro?",
                                  style: GoogleFonts.dmSans(textStyle: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.normal),
                                )),
                                const SizedBox(height: 10),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 15, 20, 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                            width: 100,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        InsertBooksList(
                                                      id: widget.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    189, 213, 234, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Text("Sim"),
                                            )),
                                        SizedBox(
                                            width: 100,
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ManualRegisterList(
                                                        id: widget.id.id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Text("Não"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          189, 213, 234, 1),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ))),
                                      ],
                                    )),
                              ],
                            ),
                          ));
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                iconSize: 25,
                color: Colors.black,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    builder: (content) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: CommentBox(
                                  onChange: (value) {
                                    setState(() {
                                      newTitle = value;
                                    });
                                  },
                                  comment: "Editar nome",
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                                ),
                                onPressed: () {
                                  editList(widget.id.id, newTitle);
                                  Navigator.pop(context);
                                },
                                child: Text("Criar"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 25,
                color: Colors.black,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Aviso!"),
                        content: const Text("Tem certeza que deseja excluir?"),
                        actions: [
                          TextButton(
                            child: const Text("Não"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Sim"),
                            onPressed: () {
                              deleteList(widget.id.id);
                              Navigator.pop(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ListScreen()));
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
            bottom: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  child: Text("Para ler", style: GoogleFonts.dmSans(textStyle: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal))),
                ),
                Tab(
                  child: Text("Lidos", style: GoogleFonts.dmSans(textStyle: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal))),
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: booksReading.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: BookReading(
                      name: booksReading[index].name,
                      author: booksReading[index].author),
                );
              },
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Books(
                      book: books[index],
                    ),
                  );
                }),
          ])),
    );
  }
}
