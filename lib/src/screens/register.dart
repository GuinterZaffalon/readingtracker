import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readingtracker/src/components/comment.dart';
import 'package:readingtracker/src/components/date.dart';
import 'package:readingtracker/src/components/ratting.dart';
import 'package:readingtracker/src/model/ServiceCoverGet.dart';
import 'package:readingtracker/src/screens/perfil.dart';
import '../model/sqflite_helper.dart';
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
  TextEditingController dateController = TextEditingController();
  int rating = 0;
  String comment = "";
  String commentNotFinished = "";
  String cover = "";
  bool isLoading = false;
  late DateTime date;
  int currentStep = 0;
  final sqfliteHelper = SqfliteHelper();
  bool get isFrirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;
  bool isComplete = false;

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

  List<Step> steps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text(""),
          content: DatePickerField(onDateSelected: (date) {
            setState(() {
              this.date = date;
            });
          }),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text(""),
          content: Ratting(rattingStar: (rating) {
            setState(() {
              this.rating = rating.toInt();
            });
          }),
        ),
    Step(
      isActive: currentStep >= 2,
      title: const Text(""),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommentBox(comment: "Gostaria de anotar algo", onChange: (value) {
              setState(() {
                comment = value;
              });
            }),
          ],
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
        title: const Text("ReadingTracker"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              isLoading ?
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              :
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        if (cover.isEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Text(
                                  widget.registro.title!,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                child: Text(widget.registro.author!),
                              ),
                              Text(widget.registro.publisher!),
                              Text(
                                widget.registro.editionYear?.isNotEmpty == true
                                    ? widget.registro.editionYear!
                                    : 'Ano não informado',
                              ),
                            ],
                          )
                        else
                          Row(
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
                                  SizedBox(
                                    width: 180,
                                    child:
                                    Text(widget.registro.publisher!, style: TextStyle(overflow: TextOverflow.ellipsis),),
                                  ),
                                  Text(
                                    widget.registro.editionYear?.isNotEmpty == true
                                        ? widget.registro.editionYear!
                                        : 'Ano não informado',
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 15),
              if (!isLoading)
                SizedBox(
                  height: 300,
                  child: Stepper(
                    steps: steps(),
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    controlsBuilder: (context, details) =>
                        Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Row(
                        children: [
                          if (!isFrirstStep)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                child: const Text("Voltar"),
                              ),
                            ),
                          const SizedBox(width: 16),
                          currentStep >= 2 ?
                          // const SizedBox()
                          Expanded(child:
                          ElevatedButton(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const perfilPage(),
                                ),
                              );
                            },
                            child: const Text("Cadastrar"),
                          ))
                              :
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              child: const Text("Avançar"),

                              // Text(isLastStep ? "Finalizar" : "Avançar"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onStepContinue: () {
                      if (isLastStep) {
                        setState(() {
                          isComplete = true;
                        });
                      } else {
                        setState(() {
                          currentStep += 1;
                        });
                      }
                    },
                    onStepTapped: (step) =>
                        setState(() => currentStep = step),
                    onStepCancel: () {
                      if (!isFrirstStep) {
                        setState(() => currentStep -= 1);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  }
