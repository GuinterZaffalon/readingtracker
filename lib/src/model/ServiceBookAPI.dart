import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static Future<List<dynamic>> getBooks(String search) async {
    final url = Uri.parse(
        "http://openlibrary.org/search.json?q=$search&fields=key,title,author_name,isbn&sort=new");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['docs'] ?? [];
      } else {
        print("Erro ao buscar livros: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Erro durante a requisição: $e");
      return [];
    }
  }
}