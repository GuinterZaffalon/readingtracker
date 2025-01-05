import 'package:flutter/material.dart';

class CommentBox extends StatelessWidget {
  final Function(String) onChange;

  const CommentBox({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Gostaria de anotar algo?",
            style: TextStyle(fontSize: 20)),
        const SizedBox(height: 10),
        Padding(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
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