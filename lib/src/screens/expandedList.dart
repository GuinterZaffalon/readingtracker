import 'package:flutter/material.dart';
import 'package:readingtracker/src/model/sqflite_helper.dart';
import '../components/listItems.dart';

class ListItemsObject implements ListItemsInterface {
  @override
  late String title;
  late int id;

  ListItemsObject(this.title, this.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
        title: const Text("ReadingTracker"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(children: [
              Text(
                widget.title.title,
                style: const TextStyle(
                    fontSize: 30,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.add_rounded),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () {}),
                  IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () {}),
                ],
              )
            ]))
      ])),
    );
  }
}
