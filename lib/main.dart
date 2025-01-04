import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readingtracker/src/model/ServiceBookAPI.dart';
import 'package:readingtracker/src/screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  bool isLoading = false;

  Future<void> fetchBooks(String search) async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await BookService.getBooks(search);
      setState(() {
        _books = result;
      });
    } catch (e) {
      print('Erro ao buscar livros: $e');
    } finally {
       setState(() {
         isLoading = false;
       });
    }
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                fetchBooks(value);
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    fetchBooks(_searchController.text);
                  },
                  child: const Icon(Icons.search),
                ),
                contentPadding: const EdgeInsets.all(15.0),
                hintText: 'Search ',
              ),
            ),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator(), heightFactor: 3)
              :
          Expanded(
            child: _books.isEmpty
                ? const Center(child: Text("Busque um livro para começar."))
                : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                final title = book['title'] ?? 'Título desconhecido';
                final author = (book['author_name'] as List<dynamic>?)
                    ?.join(', ') ??
                    'Autor desconhecido';
                final editionYear = book['first_publish_year'] ?? 'Ano desconhecido';
                final editora = book['publisher'] ?? 'Editora desconhecida';
                return ListTile(
                  title: Text(title),
                  subtitle: Text('Autor: $author\nEditora: $editora\nAno: $editionYear'),
                  style: ListTileStyle.list,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                        Register(registro: {
                          'title': title,
                          'author': author,
                          'editionYear': editionYear,
                          'publisher': editora
                        },)));
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(189, 213, 234, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.add_home_outlined),
              color: Colors.black,
              onPressed: () {
                // Ação para o ícone de início
              },
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_2_outlined),
                color: Colors.black
            ),
          ],
        ),
      ),
    );
  }
}
