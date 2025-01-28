import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class BookReadingInterface {
  late String title;
  late String author;
}

class BookReading extends StatefulWidget {
  final String title;
  final String author;

  BookReading({Key? key, required this.title, required this.author});
  @override
  _BookReadingState createState() => _BookReadingState();
}

class _BookReadingState extends State<BookReading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10,30,10,0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(widget.author)
            ],
          ),
        ),
      ),
    );
  }
}