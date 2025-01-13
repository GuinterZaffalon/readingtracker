import 'package:flutter/material.dart';
import 'package:readingtracker/src/components/books.dart';
import '../../main.dart';
import '../../sqflite_helper.dart';
import '../components/navigationBar.dart';

class perfilPage extends StatefulWidget {
  const perfilPage({Key? key}) : super(key: key);

  @override
  State<perfilPage> createState() => _perfilPageState();
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


class _perfilPageState extends State<perfilPage> {
  final sqfliteHelper = SqfliteHelper();
  late List<BooksInterface> books = [];
  bool isFiltered = false;

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

 void filterBooksByDate(DateTime startDate, DateTime endDate) async {
   setState(() {
     books = books.where((book) {
       if (book.date == null || book.date!.isEmpty) return false;

       try {
         final bookDate = DateTime.parse(book.date!);
         isFiltered = true;
         return bookDate.isAfter(startDate.subtract(Duration(days: 1))) &&
             bookDate.isBefore(endDate.add(Duration(days: 1)));
       } catch (e) {
         return false;
       }
     }).toList();
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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                  children: [
                    Text(
                      "Livros lidos!",
                      style: TextStyle
                        (fontSize: 20,
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                     IconButton(
                          icon: const Icon(Icons.filter_list_outlined),
                          iconSize: 35,
                          color: Colors.black,
                          onPressed: () async {
                            final dateRange = await (
                                showDateRangePicker(
                                  context: context,
                                  confirmText: "Confirmar",
                                  cancelText: "Cancelar",
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                )
                            );
                            if (dateRange != null) {
                              filterBooksByDate(dateRange.start, dateRange.end);
                            }
                          },
                        ), isFiltered ?
                    TextButton(onPressed: () async {
                      saveBooksFinished();
                      setState(() {
                        isFiltered = false;
                      });
                    }, child: Text("Limpar", style: TextStyle(color: Colors.black),),) :
                    Container()
                  ]
              )
            ),
          Expanded(
            child:
              ListView.builder(
                shrinkWrap: true,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Books(book: books[index]),
                  );
                },
              )
          )
        ],
      ),
        bottomNavigationBar: NavigationBottomBar()
    );
  }
}
