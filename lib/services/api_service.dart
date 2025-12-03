import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Map<String, dynamic>>> fetchProducts({int limit = 5}) async {
    final uri = Uri.parse('https://fakestoreapi.com/products?limit=$limit');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Falha ao consumir API externa: ${res.statusCode}');
  }
}