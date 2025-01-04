import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(189, 213, 234, 1),
          title: const Text("ReadingTracker"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Acabou a leitura?", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Sim"), style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(40, 10, 40, 10)))),
                ElevatedButton(onPressed: () {}, child: Text("Não"), style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(40, 10, 40, 10)))),
              ],
            )
          ],
        ),
    );
  }
}
