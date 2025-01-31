import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentBox extends StatelessWidget {
  final Function(String) onChange;
  final String comment;

  const CommentBox({Key? key, required this.onChange, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(comment,
          style: GoogleFonts.dmSans(textStyle: TextStyle(
              fontSize: 25, fontWeight: FontWeight.normal))),
        const SizedBox(height: 10),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 14, 0, 10),
            child: TextField(
              onChanged: onChange,
              decoration: InputDecoration(
                labelText: "Escreva aqui",
                filled: true,
                prefixIcon: Icon(Icons.note_alt_outlined),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                      Color.fromRGBO(189, 213, 234, 1)),
                ),
              ),
              maxLines: null,
            ))
      ]
    );
  }
}