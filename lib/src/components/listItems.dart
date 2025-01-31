import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ListItemsInterface {
  late int id;
  late String title;
}

class ListItems extends StatelessWidget {
  final ListItemsInterface title;
  final ListItemsInterface id;
  const ListItems({Key? key, required this.title, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
        child: Padding(
          padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10,),
              const Icon(Icons.list_rounded, color: Colors.black, size: 35,),
              const VerticalDivider(width:20, color: Colors.black12, endIndent: 10, indent: 10, thickness: 2,),
              Text(title.title, style: GoogleFonts.dmSans(textStyle: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold))),
            ],
          )
        )
    )
    );
  }
}