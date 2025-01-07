import 'dart:convert';

import 'package:flutter/material.dart';

abstract class BooksInterface {
  String? title;
  String? author;
  String? publisher;
  int? editionYear;
  String? cover;
  int? rating;
  String? date;
  String? comment;
}

class Books extends StatelessWidget {
  final BooksInterface book;
  const Books({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                12),
            boxShadow: [
              BoxShadow(
                color:
                Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding:
          const EdgeInsets.all(10),
          child: Row(
            children: [ book.cover == null ? Container() :
              Image.memory(
                base64Decode(book.cover!),
                width: 80,
                height: 130,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title!,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(book.author!, style: const TextStyle(
                    overflow: TextOverflow.ellipsis)),
                  Text(book.publisher!, style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  )),
                  Text(
                    book.editionYear.toString() != null
                        ? book.editionYear!.toString()
                        : 'Ano não informado',
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}