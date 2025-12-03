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

  static Future<Map<String, dynamic>> fetchAddressByCep(String cep) async {
    final onlyDigits = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (onlyDigits.length != 8) {
      throw Exception('CEP inválido. Use 8 dígitos.');
    }
    final url = Uri.parse('https://viacep.com.br/ws/$onlyDigits/json/');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Falha ao consultar CEP (${res.statusCode})');
    }
    final jsonBody = json.decode(res.body) as Map<String, dynamic>;
    if (jsonBody['erro'] == true) {
      throw Exception('CEP não encontrado.');
    }
    return {
      'cep': jsonBody['cep'],
      'logradouro': jsonBody['logradouro'],
      'bairro': jsonBody['bairro'],
      'cidade': jsonBody['localidade'],
      'estado': jsonBody['uf'],
      'complemento': jsonBody['complemento'],
    };
  }

  static Future<Map<String, dynamic>?> fetchProductByBarcode(String barcode) async {
    final digits = barcode.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 8) {
      throw Exception('Código de barras inválido.');
    }
    final url = Uri.parse('https://world.openfoodfacts.org/api/v2/product/$digits.json');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Falha ao consultar produto (${res.statusCode})');
    }
    final body = json.decode(res.body) as Map<String, dynamic>;
    if ((body['status'] ?? 0) != 1) {
      return null;
    }
    final p = body['product'] as Map<String, dynamic>;
    return {
      'name': p['product_name'] ?? p['generic_name'] ?? '',
      'brand': (p['brands'] ?? '').toString(),
      'categories': (p['categories'] ?? '').toString(),
      'description': p['ingredients_text'] ?? p['description'] ?? '',
    };
  }
}