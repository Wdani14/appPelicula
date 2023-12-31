import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;
  final String token;

  MovieDetailScreen({required this.movie, required this.token});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Map<String, dynamic>? _movieDetails;
  List<dynamic> _cast = [];

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
    _fetchCast();
  }

  Future<void> _fetchMovieDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movie['id']}?api_key=78c3880f42f17ceb75e74371f28ec8ec'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      setState(() {
        _movieDetails = jsonResponse;
      });
    } else {}
  }

  Future<void> _fetchCast() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${widget.movie['id']}/credits?api_key=78c3880f42f17ceb75e74371f28ec8ec'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> cast = jsonResponse['cast'];
      setState(() {
        _cast = cast;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie['title'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500/${widget.movie['poster_path']}',
                    width: 200,
                    height: 300,
                  ),
                  SizedBox(height: 16),
                  _movieDetails != null
                      ? Text(
                          _movieDetails!['overview'],
                          textAlign: TextAlign.center,
                        )
                      : CircularProgressIndicator(),
                ],
              ),
            ),
            if (_cast.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Actores:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _cast.map<Widget>((actor) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  'https://image.tmdb.org/t/p/w200/${actor['profile_path']}',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                actor['name'],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Volver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
