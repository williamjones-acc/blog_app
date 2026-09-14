import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:3000";

  // GET semua artikel
  Future<List<dynamic>> getPosts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/posts"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"];
    }

    throw Exception("Gagal mengambil artikel");
  }

  // GET semua kategori
  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/categories"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"];
    }

    throw Exception("Gagal mengambil kategori");
  }

  // POST artikel
  Future<void> addPost(
    String judul,
    String isi,
    int idCategory,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/posts"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "judul": judul,
        "isi": isi,
        "id_category": idCategory,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal menambahkan artikel");
    }
  }

  // PUT artikel
  Future<void> updatePost(
    int id,
    String judul,
    String isi,
    int idCategory,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/posts/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "judul": judul,
        "isi": isi,
        "id_category": idCategory,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal mengubah artikel");
    }
  }

  // DELETE artikel
  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/posts/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal menghapus artikel");
    }
  }
}