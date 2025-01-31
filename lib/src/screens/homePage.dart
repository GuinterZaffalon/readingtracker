import 'package:flutter/material.dart';
import 'package:readingtracker/src/components/navigationBar.dart';
import 'package:readingtracker/src/model/ServiceBookAPI.dart';
import 'package:readingtracker/src/screens/manualRegistrer.dart';
import 'package:readingtracker/src/screens/register.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: const Color.fromRGBO(149,203,226, 1),
        title: Text("reading tracker", style: GoogleFonts.dmSans(),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

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
                    color: Colors.black,
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
                hintText: Text("Buscar livro", style: GoogleFonts.dmSans(),).data,
              ),
            ),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(
              child: CircularProgressIndicator(), heightFactor: 3)
              : notFound
              ?   Column(children: [
            Center(child: Text("Livro não encontrado.", style: GoogleFonts.dmSans(),)),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualRegister(),
                      ));
                },
                child: Text("Cadastrar manualmente", style: GoogleFonts.dmSans()))
          ])
              : Expanded(
            child: _books.isEmpty
                ? Center(
                child: Text("Busque um livro para começar.", style: GoogleFonts.dmSans()))
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
