import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readingtracker/src/components/bookReading.dart';
import 'package:readingtracker/src/components/booksList.dart';
import 'package:readingtracker/src/model/sqflite_helper.dart';
import 'package:readingtracker/src/screens/insertBooksList.dart';
import 'package:readingtracker/src/screens/manualRegisterList.dart';
import '../components/books.dart';
import '../components/listItems.dart';

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
            backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
            title: Text(
              widget.title.title,
              style: const TextStyle(
                  fontSize: 30,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold),
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
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Terminou o livro?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InsertBooksList(
                                      id: widget.id,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Sim"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManualRegisterList(
                                      id: widget.id.id,
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Não"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
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
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                "Editar nome da lista",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        newTitle = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Escreva aqui",
                                      filled: true,
                                      prefixIcon: Icon(Icons.note_alt_outlined),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                189, 213, 234, 1)),
                                      ),
                                    ),
                                    maxLines: null,
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  newTitle == widget.title.title
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                          ),
                                          onPressed: () {},
                                          child: const Text("Salvar"),
                                        )
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          onPressed: () async {
                                            await editList(
                                                widget.id.id, newTitle);
                                            setState(() {
                                              widget.title.title = newTitle;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Salvar"),
                                        ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      AlertDialog(
                                        title: const Text("Cancelar"),
                                        content: const Text(
                                            "Tem certeza que deseja cancelar?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Sim"),
                                            onPressed: () {
                                              deleteList(widget.id.id);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("Nao"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Excluir Lista"),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
              ),
            ],
            bottom: const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  child: Text("Para ler"),
                ),
                Tab(
                  child: Text("Lidos"),
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
