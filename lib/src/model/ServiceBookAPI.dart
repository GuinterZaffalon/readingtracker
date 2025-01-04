import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static Future<List<dynamic>> getBooks(String search) async {
    final searchParam = search.split("+");
    final url = Uri.parse(
        "http://openlibrary.org/search.json?q=$searchParam&fields=key,title,author_name,number_of_pages_median,isbn,first_publish_year,publisher&sort=new");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
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