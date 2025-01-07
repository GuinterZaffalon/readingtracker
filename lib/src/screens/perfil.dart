import 'package:flutter/material.dart';

class perfilPage extends StatefulWidget {
  const perfilPage({Key? key}) : super(key: key);

  @override
  State<perfilPage> createState() => _perfilPageState();
}

class _perfilPageState extends State<perfilPage> {


  superInitState() {
    super.initState();
  }

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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 10, 0),
            child: Text("Suas leituras!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}
