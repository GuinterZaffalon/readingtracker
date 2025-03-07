import 'package:flutter/material.dart';
import 'package:readingtracker/src/screens/list.dart';
import '../screens/homePage.dart';
import '../screens/perfil.dart';

class NavigationBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(

      height: 50,
      color: const Color.fromRGBO(149,203,226, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.add_home_outlined),
            iconSize: 27,
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ));
            },
          ),
          IconButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListScreen(),
                  ));
            },
            icon: const Icon(Icons.list_rounded),
            iconSize: 27,
            color: Colors.black,
          ),
          IconButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const perfilPage(),
                    ));
              },
              icon: const Icon(Icons.person_2_outlined),
              iconSize: 27,
              color: Colors.black),
        ],
      ),
    );
  }
}