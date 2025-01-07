import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readingtracker/src/components/comment.dart';
import 'package:readingtracker/src/components/date.dart';
import 'package:readingtracker/src/components/ratting.dart';
import 'package:readingtracker/src/model/ServiceCoverGet.dart';
import '../../sqflite_helper.dart';
import '../model/ServiceBookAPI.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

class Registro {
  String? title;
  String? author;
  String? publisher;
  String? isbn;
  String? editionYear;

  Registro(
      {this.title, this.author, this.publisher, this.isbn, this.editionYear});
}

class Register extends StatefulWidget {
  final Registro registro;
  const Register({super.key, required this.registro});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool? isReading;
  TextEditingController dateController = TextEditingController();
  int rating = 0;
  String comment = "";
  String commentNotFinished = "";
  String cover = "";
  bool isLoading = false;
  late DateTime date;
  late PageController _pageController;
  int _currentPage = 0;
  final sqfliteHelper = SqfliteHelper();

  initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    if (widget.registro.isbn == null || widget.registro.isbn == '') {
      return;
    } else {
      fetchBooks(widget.registro.isbn!);
    }
  }

  Future<void> fetchBooks(String isbn) async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await CoverService.getCover(isbn);
      setState(() {
        cover = result;
      });
    } catch (e) {
      print('Erro ao buscar livros: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          isLoading
              ?
          Expanded(
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Carregando...'),
                    ],
                  )
              ))
              : cover.isEmpty
              ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    12),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding:
              const EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.registro.title!,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(widget.registro.author!),
                      Text(widget.registro.publisher!),
                      Text(
                        widget.registro.editionYear?.isNotEmpty ==
                            true
                            ? widget.registro.editionYear!
                            : 'Ano não informado',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    12),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding:
              const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.memory(
                    base64Decode(cover),
                    width: 80,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.registro.title!,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(widget.registro.author!),
                      Text(widget.registro.publisher!),
                      Text(
                        widget.registro.editionYear?.isNotEmpty ==
                            true
                            ? widget.registro.editionYear!
                            : 'Ano não informado',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          isLoading ? const Text("") :
              Container(
                child: Column(
              children: [
                const Text("Acabou a leitura?", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isReading = false;
                        });
                      },
                      child: const Text("Sim"),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isReading = true;
                        });
                      },
                      child: const Text("Não"),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.fromLTRB(40, 10, 40, 10)),
                      ),
                    ),
                  ],
                ),
              ])),
           Container(
              child: isReading == null
                  ? const Text("")
                  : (isReading! //aqui começa o trecho que muda de acordo com o sim ou não
                  ? Column(children: [
                const SizedBox(height: 15),
                    DatePickerField(onDateSelected: (date) {
                      setState(() {
                        this.date = date;
                      });
                    }),
                const SizedBox(height: 15),
                CommentBox(onChange: (value) {
                  setState(() {
                    commentNotFinished = value;
                  });
                })
              ])
                  : Column(children: [
                const SizedBox(height: 15),
                DatePickerField(onDateSelected: (date) {
                  setState(() {
                    this.date = date;
                  });
                }),
                Ratting(rattingStar: (rating) {
                  setState(() {
                    this.rating = rating.toInt();
                  });
                }),
                const SizedBox(height: 15),
                CommentBox(onChange: (value) {
                  setState(() {
                    comment = value;
                  });
                }
                ),
                Row( //botão de salvar atual
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(
                              40, 10, 40, 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              final book = {
                                "title": widget.registro.title,
                                "author": widget.registro.author,
                                "publisher": widget.registro.publisher,
                                "editionYear": widget.registro.editionYear,
                                "cover": cover,
                                "comment": comment,
                                "date": date.toString(),
                                "rating": rating,
                              };
                              await sqfliteHelper.insertBookFinished(book);
                            },
                            child: const Text("Salvar"),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.fromLTRB(
                                      40, 10, 40, 10)),
                            ),
                          ))
                    ])
              ])),
            ),
        ],
      ),
    );
  }
}