import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/movie.dart';

class MovieService {

  Future<List<Movie>> obtenerPeliculas() async {

    final String jsonString =
        await rootBundle.loadString(
      'assets/data/peliculas.json',
    );

    final List<dynamic> jsonData =
        json.decode(jsonString);

    return jsonData
        .map(
          (pelicula) => Movie.fromJson(pelicula),
        )
        .toList();

  }

}