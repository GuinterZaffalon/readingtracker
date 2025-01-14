import 'package:flutter/material.dart';
import 'package:readingtracker/src/model/sqflite_helper.dart';
import 'package:readingtracker/src/components/comment.dart';

import '../components/navigationBar.dart';

class List extends StatefulWidget {
  const List({Key? key}) : super(key: key);

  @override
  State<List> createState() => _ListState();
}

class _ListState extends State<List> {
  String comment = "";
  SqfliteHelper sqfliteHelper = SqfliteHelper();

  Future<void> saveList(comment) async {
    await sqfliteHelper.createBookList(comment);
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
              child: Row(children: [
                Text(
                  "Livros lidos!",
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                    icon: const Icon(Icons.add_rounded),
                    iconSize: 35,
                    color: Colors.black,
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )),
                          builder: (content) {
                            return Container(
                              height: 400,
                              child: Column(
                                children: [
                                  SizedBox(height: 15,),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: CommentBox(
                                        onChange: (value) {
                                          setState(() {
                                            comment = value;
                                          });
                                    }, comment: "Qual o nome da lista?",)
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.fromLTRB(60, 0, 60, 0)
                                      ),
                                      onPressed: () {
                                        saveList(comment);
                                      },
                                      child: Text("Criar"))
                                ],
                              )
                            );
                          });
                    }),
              ]))
        ],
      ),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }
}
