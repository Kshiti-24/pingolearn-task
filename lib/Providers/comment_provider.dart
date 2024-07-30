import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pingolearn_task/Models/comment.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> _comments = [];
  String? _error;

  List<Comment> get comments => _comments;
  String? get error => _error;

  Future<void> fetchComments() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/comments'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _comments = data.map((item) => Comment.fromJson(item)).toList();
        _error = null;
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      print('Error: $e');
      _error = e.toString();
    }
    notifyListeners();
  }
}
