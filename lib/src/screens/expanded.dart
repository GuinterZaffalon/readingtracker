import 'dart:convert';

import 'package:flutter/material.dart';
import '../../sqflite_helper.dart';
import '../components/books.dart';

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

  // @override
  // void initState() {
  //   super.initState();
  //   getBooks().then((value) {
  //     setState(() {
  //       books = value;
  //     });
  //   });
  // }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Livro"),
      ),
      body: FutureBuilder<BookData?>(
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
          return Padding(
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
                      ? const Text("Capa não disponível")
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
                      Text(
                        book.title ?? 'Título não disponível',
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(book.author ?? 'Autor não informado'),
                      Text(book.publisher ?? 'Editora não informada'),
                      Text(book.editionYear != 0
                          ? 'Ano: ${book.editionYear}'
                          : 'Ano não informado'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}