import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readingtracker/src/components/starBook.dart';
import 'package:readingtracker/src/screens/perfil.dart';
import '../model/sqflite_helper.dart';
import '../components/books.dart';
import '../components/navigationBar.dart';
import 'package:intl/intl.dart';

import 'homePage.dart';
import 'list.dart';

class ExpandedPage extends StatefulWidget {
  final int bookId;
  const ExpandedPage({Key? key, required this.bookId}) : super(key: key);

  @override
  State<ExpandedPage> createState() => _ExpandedPageState();
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

class _ExpandedPageState extends State<ExpandedPage> {
  late final int id = widget.bookId;
  final sqfliteHelper = SqfliteHelper();
  late List<BooksInterface> books = [];

  Future<BookData?> getBooks() async {
    final result = await sqfliteHelper.getBookById(id);
    if (result.isNotEmpty) {
      final book = result.first;
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
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(149, 203, 226, 1),
        title: Text(
          "reading tracker",
          style: GoogleFonts.dmSans(),
        ),
        centerTitle: true,
      ),
      body: Column(children: [
        FutureBuilder<BookData?>(
          future: getBooks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Livro não encontrado.'));
            }

            final book = snapshot.data!;
            return Column(children: [
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        book.cover == null || book.cover!.isEmpty
                            ? Text(
                                "Capa não \n disponível",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              )
                            : Image.memory(
                                base64Decode(book.cover!),
                                width: 80,
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 180,
                                child: Text(
                                  book.title ?? 'Título não disponível',
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )),
                            SizedBox(
                              width: 180,
                              child: Text(book.author ?? 'Autor não informado',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                  book.publisher ?? 'Editora não informada',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis)),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                  book.editionYear != 0
                                      ? 'Ano: ${book.editionYear}'
                                      : 'Ano não informado',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                          right: 10,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(0, 0, 0, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            label: Text("Enviar",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ))
              ]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 0.10 * MediaQuery.of(context).size.height,
                      width: 0.43 * MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Text("Livro lido em:",
                            style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 10),
                        Text(
                          book.date != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(book.date!))
                              : 'Nenhum comentário',
                          style: TextStyle(fontSize: 16),
                        ),
                      ]),
                    )),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 0.10 * MediaQuery.of(context).size.height,
                      width: 0.43 * MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Text("Avaliação",
                            style: GoogleFonts.dmSans(
                                textStyle: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(height: 10),
                        RatingStars(rating: book.rating!),
                      ]),
                    ))
              ]),
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 0.9 * MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                      Text("Comentários",
                          style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      Text(
                          book.comment!.isNotEmpty
                              ? book.comment!
                              : 'Nenhum comentário',
                          style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal)),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                    ]),
                  )),
            ]);
          },
        ),
      ]),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }
}
