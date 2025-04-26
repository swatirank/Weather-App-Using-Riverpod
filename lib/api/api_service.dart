import 'package:http/http.dart' as http;
import 'package:riverpod_app/api/post_model.dart';
import 'dart:convert';
import 'user_model.dart';

class ApiService {
  Future<List<User>> fetchUsers() async {
    final res = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );
    if (res.statusCode == 200) {
      final List jsonData = json.decode(res.body);
      return jsonData.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<User>> fetchUsersById(int id) async {
    final res = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    );
    if (res.statusCode == 200) {
      final jsonData = json.decode(res.body);
      return [User.fromJson(jsonData)];
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Post>> fetchPost() async {
    final res = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    if (res.statusCode == 200) {
      final List jsonData = json.decode(res.body);
      return jsonData.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<bool> createUser(String name, String email, int phone) async {
    final res = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      }, // telling the server we are sending json data
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
      }), // convert a dart map to json string
    );
    if (res.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<bool> updateUser(int id, String name, String email) async {
    final res = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': name,
        'email': email,
      }), // convert a dart map to json string
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<bool> deleteUser(int id) async {
    final res = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
    );
    if (res.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update user');
    }
  }
}

// converting json into dart object
