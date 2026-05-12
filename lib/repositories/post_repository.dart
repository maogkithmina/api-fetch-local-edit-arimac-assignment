import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostRepository {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const int limit = 15; // Limit to 15 posts

  // Fetch posts from API
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/posts?_limit=$limit'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
