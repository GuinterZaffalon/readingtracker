import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readingtracker/src/components/starBook.dart';
import '../../sqflite_helper.dart';
import '../screens/expanded.dart';

abstract class BooksInterface {
  int? id;
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
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExpandedPage(bookId: book.id!)));
        },
        child: Container(
            child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
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
            book.cover == null || book.cover!.isEmpty
                ? Text(
                    "Capa não \n disponível",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  )
                : Image.memory(
                    base64Decode(book.cover!),
                    width: 80,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 180,
                    child: Text(
                      book.title!,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    )),
                const SizedBox(height: 5),
                SizedBox(
                  width: 180,
                  child: Text(book.author!,
                      style: const TextStyle(overflow: TextOverflow.ellipsis)),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 180,
                  child:
                  Text(book.publisher!,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      )),
                ),

                const SizedBox(height: 5),
                RatingStars(rating: book.rating!),
              ],
            ),
          ],
        ),
      ),
    )));
  }
}
