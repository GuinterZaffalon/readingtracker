import 'package:flutter/material.dart';

abstract class ListItemsInterface {
  late String title;
}

class ListItems extends StatelessWidget {
  final ListItemsInterface title;
  const ListItems({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Text(title.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          )
        )
    )
    );
  }
}