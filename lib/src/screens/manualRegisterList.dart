import "package:flutter/material.dart";

import "../model/sqflite_helper.dart";

class ManualRegisterList extends StatefulWidget {
  const ManualRegisterList({Key? key}) : super(key: key);

  @override
  State<ManualRegisterList> createState() => _ManualRegisterListState();
}

class _ManualRegisterListState extends State<ManualRegisterList> {
  SqfliteHelper sqfliteHelper = SqfliteHelper();
  String name = "";
  String author = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
        title: const Text("ReadingTracker"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
    );
  }
}