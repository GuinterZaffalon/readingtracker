import "package:flutter/material.dart";
import "package:readingtracker/src/components/listItems.dart";
import "package:readingtracker/src/screens/expandedList.dart";

import "../components/comment.dart";
import "../model/sqflite_helper.dart";

class ListItemsObject implements ListItemsInterface{
  @override
  late String title;
  late int id;

  ListItemsObject(this.title, this.id);
}

class ManualRegisterList extends StatefulWidget {
  final int id;
  const ManualRegisterList({Key? key, required, required this.id})
      : super(key: key);

  @override
  State<ManualRegisterList> createState() => _ManualRegisterListState();
}

class _ManualRegisterListState extends State<ManualRegisterList> {
  SqfliteHelper sqfliteHelper = SqfliteHelper();
  String title = "";
  String author = "";
  int currentStep = 0;
  bool get isFrirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  Future<void> saveList() async {
    await sqfliteHelper.insertReadingBookInList(widget.id, title, author);
  }

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
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
          title: const Text("ReadingTracker"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
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
                currentStep < steps().length - 1
                    ? Expanded(
                        child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: const Text("Proximo")),
                      )
                    : ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: const Text("Finalizar")),
              ],
            ),
          ),
          onStepContinue: () {
            if (!isLastStep) {
              setState(() {
                currentStep += 1;
              });
            } else {
              saveList();
              Navigator.pop(context);
            }
          },
          onStepCancel: () {
            if (!isFrirstStep) {
              setState(() {
                currentStep -= 1;
              });
            }
          },
        )));
  }
}
