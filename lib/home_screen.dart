import 'package:flutter/material.dart';
import 'movie_list.dart';

class HomeScreen extends StatelessWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Películas populares')),
      body: MovieList(token: token),
    );
  }
}
