import 'package:flutter/material.dart';
import 'package:readingtracker/src/screens/homePage.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Tracker',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(189, 213, 234, 1)),
      ),
      home: const MyHomePage(),
    );
  }
}


