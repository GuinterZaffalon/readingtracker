import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readingtracker/src/model/ServiceCoverGet.dart';

import '../model/ServiceBookAPI.dart';

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
  String cover = "";
  bool isLoading = false;

  initState() {
    super.initState();
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

  Future<void> _showDatePicker() async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_pickedDate != null) {
      setState(() {
        dateController.text =
            "${_pickedDate.day}/${_pickedDate.month}/${_pickedDate.year}";
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
              ? const CircularProgressIndicator()
              : cover.isEmpty
                  // ? Column(
                  //     children: [
                  //       Text(widget.registro.title!),
                  //       Text(widget.registro.author!),
                  //       Text(widget.registro.publisher!),
                  //       Text(widget.registro.editionYear!),
                  //     ],
                  //   )
                  ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Cor de fundo
                borderRadius: BorderRadius.circular(
                    12), // Raio da borda arredondada
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.grey.withOpacity(0.3), // Sombra suave
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Deslocamento da sombra
                  ),
                ],
              ),
              padding:
              const EdgeInsets.all(10), // Espaçamento interno
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.registro.title!,
                        style: const TextStyle(
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
                          color: Colors.white, // Cor de fundo
                          borderRadius: BorderRadius.circular(
                              12), // Raio da borda arredondada
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.3), // Sombra suave
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // Deslocamento da sombra
                            ),
                          ],
                        ),
                        padding:
                            const EdgeInsets.all(10), // Espaçamento interno
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
          const SizedBox(height: 10),
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
          Expanded(
            child: Container(
              child: isReading == null
                  ? const Text("")
                  : (isReading!
                      ? const Text("Ainda estou lendo")
                      : Column(children: [
                          const SizedBox(height: 10),
                          Text("Quando terminou a leitura?",
                              style: TextStyle(fontSize: 20)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: TextField(
                                controller: dateController,
                                onTap: () {
                                  _showDatePicker();
                                },
                                decoration: InputDecoration(
                                  labelText: "Insira a data",
                                  filled: true,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(189, 213, 234, 1)),
                                  ),
                                ),
                                readOnly: true,
                              )),
                          Text("Quantas estrelas daria para a obra?",
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                this.rating = rating.toInt();
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Text("Gostaria de deixar alguma anotação?",
                              style: TextStyle(fontSize: 20)),
                          const SizedBox(height: 10),
                          Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    comment = value;
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
                                        color:
                                            Color.fromRGBO(189, 213, 234, 1)),
                                  ),
                                ),
                                maxLines: null,
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: ElevatedButton(
                                      onPressed: () {},
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
          ),
        ],
      ),
    );
  }
}
