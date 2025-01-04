import 'dart:convert';
import 'package:http/http.dart' as http;

class CoverService {
  static Future<String> getCover(String isbn) async {
    final url = Uri.parse(
        'https://covers.openlibrary.org/b/isbn/$isbn-L.jpg?default=false');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      } else {
        print("Erro ao buscar capa: ${response.statusCode}");
        return '';
      }
    } catch (e) {
      print("Erro durante a requisição: $e");
      return '';
    }
  }
}