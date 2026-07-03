class Movie {
  final int id;
  final String titulo;
  final String descripcion;
  final String imagen;
  final String video;
  final String genero;
  final String duracion;
  final double rating;

  Movie({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.video,
    required this.genero,
    required this.duracion,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json["id"],
      titulo: json["titulo"],
      descripcion: json["descripcion"],
      imagen: json["imagen"],
      video: json["video"],
      genero: json["genero"],
      duracion: json["duracion"],
      rating: (json["rating"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "titulo": titulo,
      "descripcion": descripcion,
      "imagen": imagen,
      "video": video,
      "genero": genero,
      "duracion": duracion,
      "rating": rating,
    };
  }
}