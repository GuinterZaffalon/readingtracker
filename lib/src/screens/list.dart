import 'package:flutter/material.dart';
import 'package:readingtracker/src/components/listItems.dart';
import 'package:readingtracker/src/model/sqflite_helper.dart';
import 'package:readingtracker/src/components/comment.dart';

import '../components/navigationBar.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class ListItemsObject implements ListItemsInterface{
  @override
  late String title;

  ListItemsObject(this.title);
}

class _ListScreenState extends State<ListScreen> {
  String comment = "";
  SqfliteHelper sqfliteHelper = SqfliteHelper();

  Future<void> saveList(comment) async {
    await sqfliteHelper.createBookList(comment);
  }

  // Future<List<Widget>> getLists() async {
  //   final result = await sqfliteHelper.getUserList();
  //   return result.map((list) {
  //     final listItem = ListItemsObject(list['name']);
  //     return ListItems(listItem: listItem);
  //   }).toList();
  // }

  Future<List<Widget>> getLists() async {
    final result = await sqfliteHelper.getUserList();
    // Mapeia os resultados para uma lista de widgets
    return result.map((list) {
      // Cria uma instância de ConcreteListItem
      final listItem = ListItemsObject(list['name']);
      return ListItems(title: listItem); // Passa a instância correta
    }).toList(); // Retorna uma List<Widget>
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
                  "Listas!",
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
              ])),
          FutureBuilder<List<Widget>>(
            future: getLists(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Expanded(
                  child: ListView(
                    children: snapshot.data!,
                  ),
                );
              } else {
                return const Center(child: Text('Que tal começar criando \br uma lista?'));
              }
            },
          )
        ],
      ),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }
}
