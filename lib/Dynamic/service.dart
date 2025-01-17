import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class RecipeService {
  final String apiUrl = 'http://localhost:5000/list'; // Replace with your API URL

  Future<List<RecipeModel>> fetchRecipes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
