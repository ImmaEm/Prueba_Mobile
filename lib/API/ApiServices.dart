import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_mobile_developer/Modelos/Categoria.dart';
import 'package:prueba_mobile_developer/Modelos/Articulo.dart';

class ApiService {
  static const String baseUrl = 'https://basic2.visorus.com.mx';

  // Categoria
  Future<List<Categoria>> fetchAllCategorias() async {
    final response = await http.get(Uri.parse('$baseUrl/categoria'));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final categoriasList = jsonResponse['data'] as List<dynamic>;
      return categoriasList.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categorias');
    }
  }

  Future<void> createCategoria(Categoria categoria) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categoria'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create categoria');
    }
  }

  Future<void> updateCategoria(String id, Categoria categoria) async {
    final response = await http.put(
      Uri.parse('$baseUrl/categoria/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update categoria');
    }
  }

  Future<void> deleteCategoria(String clave) async {
    final response = await http.delete(Uri.parse('$baseUrl/categoria/$clave'));

    if (response.statusCode == 200) {
      // Eliminar exitoso
    } else {
      throw Exception('Failed to delete categoria: ${response.body}');
    }
  }

  // Articulo
  Future<List<Articulo>> getArticulos() async {
    final response = await http.get(Uri.parse('$baseUrl/articulo'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Articulo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load articulos');
    }
  }

  Future<Articulo> getArticuloById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/articulo/$id'));
    if (response.statusCode == 200) {
      return Articulo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load articulo');
    }
  }

  Future<void> createArticulo(Articulo articulo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/articulo'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(articulo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create articulo');
    }
  }

  Future<void> updateArticulo(String id, Articulo articulo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/articulo/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(articulo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update articulo');
    }
  }

  Future<void> deleteArticulo(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/articulo/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete articulo');
    }
  }
}
