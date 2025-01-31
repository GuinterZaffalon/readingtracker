import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readingtracker/src/components/listItems.dart';
import 'package:readingtracker/src/model/sqflite_helper.dart';
import 'package:readingtracker/src/components/comment.dart';
import 'package:readingtracker/src/screens/expandedList.dart';

import '../components/navigationBar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class ListItemsObject implements ListItemsInterface{
  @override
  late String title;
  late int id;

  ListItemsObject(this.title, this.id);
}

class _ListScreenState extends State<ListScreen> {
  String comment = "";
  SqfliteHelper sqfliteHelper = SqfliteHelper();

  Future<void> saveList(comment) async {
    await sqfliteHelper.createBookList(comment);
  }

  Future<List<Widget>> getLists() async {
    final result = await sqfliteHelper.getUserList();
    return result.map((list) {
      final ListItemsObject listItem = ListItemsObject(list['name'], list['id']);
      return GestureDetector(
        onTap: () =>
        Navigator.push(
          context,
        MaterialPageRoute(builder: (context) => Expandedlist(
            title: listItem,
            id: listItem)
        )
        ),
            child: ListItems(title: listItem, id: listItem),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(149,203,226, 1),
          title: Text("reading tracker", style: GoogleFonts.dmSans(),),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Row(children: [
                Text(
                  "Listas!",
                  style: GoogleFonts.dmSans(textStyle: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
                ),
                Spacer(),
                IconButton(
                    icon: const Icon(Icons.add_rounded),
                    iconSize: 35,
                    color: Colors.black,
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          )),
                          builder: (content) {
                            return Padding(
                              padding: EdgeInsets.all(20.0).copyWith(
                                bottom: MediaQuery.of(context).viewInsets.bottom
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                        Navigator.pop(context);
                                      },
                                      child: Text("Criar"))
                                ],
                              )
                            );
                          });
                    }),
              ])),
          FutureBuilder<List<Widget>>(
            future: getLists(),
            builder: (context, snapshot) {
               if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Expanded(
                  child: ListView(
                    children: snapshot.data!,
                  ),
                );
              } else {
                return Center(
                    child: Text('Que tal começar criando \b uma lista?', style: GoogleFonts.dmSans(textStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.normal)),));
              }
            },
          )

        ],
      ),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }
}
