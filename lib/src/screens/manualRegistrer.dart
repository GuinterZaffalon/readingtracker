import 'package:flutter/material.dart';
import 'package:readingtracker/src/screens/perfil.dart';

import '../../sqflite_helper.dart';
import '../components/comment.dart';
import '../components/date.dart';
import '../components/ratting.dart';

class ManualRegister extends StatefulWidget {
  const ManualRegister({Key? key}) : super(key: key);

  @override
  State<ManualRegister> createState() => _ManualRegisterState();
}

class _ManualRegisterState extends State<ManualRegister> {
  String title = '';
  String author = '';
  String publisher = '';
  String rating = '';
  late DateTime date;
  String editionYear = '';
  String comment = '';
  int currentStep = 0;
  final sqfliteHelper = SqfliteHelper();
  bool get isFrirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;
  bool isComplete = false;

  List<Step> steps() => [
        Step(
            isActive: currentStep >= 0,
            title: const Text(""),
            content: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  CommentBox(
                      onChange: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      comment: "Qual o nome do livro?"),
                ]))),
        Step(
            isActive: currentStep >= 1,
            title: const Text(""),
            content: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  CommentBox(
                      onChange: (value) {
                        setState(() {
                          author = value;
                        });
                      },
                      comment: "Qual o autor do livro?"),
                ]))),
        Step(
            isActive: currentStep >= 2,
            title: const Text(""),
            content: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  CommentBox(
                      onChange: (value) {
                        setState(() {
                          publisher = value;
                        });
                      },
                      comment: "Qual a editora do livro?"),
                ]))),
        Step(
          isActive: currentStep >= 3,
          title: const Text(""),
          content: DatePickerField(onDateSelected: (date) {
            setState(() {
              this.date = date;
            });
          }),
        ),
        Step(
          isActive: currentStep >= 4,
          title: const Text(""),
          content: Ratting(rattingStar: (rating) {
            setState(() {
              this.rating = rating.toInt().toString();
            });
          }),
        ),
        Step(
          isActive: currentStep >= 5,
          title: const Text(""),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommentBox(
                    comment: "Gostaria de anotar algo?",
                    onChange: (value) {
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
          child: Column(children: [
            SizedBox(
                height: 400,
                child: Stepper(
                  steps: steps(),
                  type: StepperType.horizontal,
                  currentStep: currentStep,
                  controlsBuilder: (context, details) => Padding(
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
                        currentStep >= 5
                            ?
                            // const SizedBox()
                            Expanded(
                                child: ElevatedButton(
                                onPressed: () async {
                                  final book = {
                                    "title": title,
                                    "author": author,
                                    "publisher": publisher,
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
                            : Expanded(
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
                  onStepTapped: (step) => setState(() {
                    currentStep = step;
                  }),
                  onStepCancel: () {
                    if (!isFrirstStep) {
                      setState(() {
                        currentStep -= 1;
                      });
                    }
                  },
                ))
          ]),
        )));
  }
}
