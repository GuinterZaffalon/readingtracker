import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:readingtracker/src/components/listItems.dart';
import 'package:readingtracker/src/components/starBook.dart';
import '../model/sqflite_helper.dart';

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


class BooksList extends StatefulWidget {
  final ListItemsInterface id;
  final BooksInterface book;

  BooksList({
    Key? key,
    required this.book,
    required this.id,
  }) : super(key: key);

  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  late SqfliteHelper sqfliteHelper;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    sqfliteHelper = SqfliteHelper();
  }

  Future<void> saveBooksOnList() async {
    await sqfliteHelper.insertBookInList(widget.id.id, widget.book.id!);
  }

  Future<void> deleteBooksOnList(String tableName) async {
    await sqfliteHelper.clearTable(tableName);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Color.fromRGBO(189, 213, 234, 1)
                    : Colors.white,
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
                  widget.book.cover == null || widget.book.cover!.isEmpty
                      ? const Text(
                    "Capa não \n disponível",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  )
                      : Image.memory(
                    base64Decode(widget.book.cover!),
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
                          widget.book.title!,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 180,
                        child: Text(
                          widget.book.author!,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 180,
                        child: Text(
                          widget.book.publisher!,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      RatingStars(rating: widget.book.rating!),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(189, 213, 234, 1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              iconSize: 25,
              onPressed: () async {
                saveBooksOnList();
              },
            ),
          ),
        )
      ],
    );
  }
}

