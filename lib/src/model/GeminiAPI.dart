import "dart:convert";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiAPI {
  static Future<http.Response> getSimilarBooks(String title, String author) async {
    final apiKey = dotenv.env['GEMINI_API'];
    final prompt = "Pesquise o livro correspondente ao titulo $title e do autor $author e em um tom de bate papo, me retorne uma indicação de 5 livros parecidos com ele, com um tom de recomendação!";
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemma-3n-e4b-it:generateContent?key=$apiKey");
    final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {
            "text": prompt,
          },
        ],
      },
    ],
  });
    try{
      final response = await http.post(
        url,
        headers: {
        'Content-Type': 'application/json',
      },
      body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      return http.Response(response.body, response.statusCode);
    }
  } catch (e) {
    // Erro interno do servidor
    return http.Response(
      jsonEncode({'error': 'Internal server error'}),
      500,
      headers: {'Content-Type': 'application/json'},
    );
  }
  }
}