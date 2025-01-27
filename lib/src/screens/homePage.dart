import 'package:flutter/material.dart';
import 'package:readingtracker/src/components/navigationBar.dart';
import 'package:readingtracker/src/model/ServiceBookAPI.dart';
import 'package:readingtracker/src/screens/manualRegistrer.dart';
import 'package:readingtracker/src/screens/register.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  bool isLoading = false;
  bool notFound = false;

  Future<void> fetchBooks(String search) async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await BookService.getBooks(search);
      if (result.isEmpty) {
        setState(() {
          notFound = true;
        });
      } else {
        setState(() {
          _books = result;
        });
      }
    } catch (e) {
      setState(() {
        notFound = true;
      });
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
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(15, 12, 10, 0),
                child:
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Olá,'),
                      TextSpan(text: ' Guinter', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
            )
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
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
                hintText: 'Buscar ',
              ),
            ),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(
              child: CircularProgressIndicator(), heightFactor: 3)
              : notFound
              ?   Column(children: [
            Center(child: Text("Livro não encontrado.")),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualRegister(),
                      ));
                },
                child: Text("Cadastrar manualmente"))
          ])
              : Expanded(
            child: _books.isEmpty
                ? const Center(
                child: Text("Busque um livro para começar."))
                : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                final title =
                    book['title'] ?? 'Título desconhecido';
                final author =
                    (book['author_name'] as List<dynamic>?)
                        ?.join(', ') ??
                        'Autor desconhecido';
                final editionYear =
                    book['first_publish_year'] ??
                        'Ano desconhecido';
                final editora =
                    book['publisher'] ?? 'Editora desconhecida';
                return ListTile(
                  title: Text(title),
                  subtitle: Text(
                      'Autor: $author\nEditora: $editora\nAno: $editionYear'),
                  style: ListTileStyle.list,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(
                                registro: Registro(
                                    title: book['title']
                                        .toString(),
                                    author: (book["author_name"]
                                    as List<dynamic>?)
                                        ?.join(', '),
                                    editionYear: book[
                                    'first_publish_year']
                                        .toString(),
                                    publisher: book['publisher']
                                        .toString(),
                                    isbn: (book['isbn'][0])
                                        .toString()))));
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBottomBar(),
    );
  }
}
