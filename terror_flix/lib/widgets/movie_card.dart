import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/database_service.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool hover = false;

  bool favorito = false;

  final DatabaseService databaseService = DatabaseService();

  Future<void> agregarFavorito() async {
    try {
      await databaseService.agregarFavorito(
        titulo: widget.movie.titulo,
        descripcion: widget.movie.descripcion,
        imagen: widget.movie.imagen,
        video: widget.movie.video,
        genero: widget.movie.genero,
        duracion: widget.movie.duracion,
        rating: widget.movie.rating,
      );

      if (!mounted) return;

      setState(() {
        favorito = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Película agregada a favoritos ❤️"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
        return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: hover ? 1.05 : 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hover ? Colors.redAccent : Colors.transparent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: hover
                    ? Colors.red.withOpacity(.7)
                    : Colors.black45,
                blurRadius: hover ? 25 : 8,
                spreadRadius: hover ? 4 : 1,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.pushNamed(
                context,
                "/details",
                arguments: widget.movie,
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.asset(
                      widget.movie.imagen,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade900,
                          child: const Center(
                            child: Icon(
                              Icons.movie,
                              color: Colors.red,
                              size: 70,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.movie.titulo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.movie.descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [

                            const Icon(
                              Icons.category,
                              color: Colors.red,
                              size: 16,
                            ),

                            const SizedBox(width: 5),

                            Expanded(
                              child: Text(
                                widget.movie.genero,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [

                            const Icon(
                              Icons.schedule,
                              color: Colors.white70,
                              size: 16,
                            ),

                            const SizedBox(width: 5),

                            Text(
                              widget.movie.duracion,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),

                          ],
                        ),

                        const Spacer(),
                                                Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star,
                              size: 16,
                              color: index < widget.movie.rating.round()
                                  ? Colors.redAccent
                                  : Colors.grey,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: favorito
                                ? null
                                : agregarFavorito,
                            icon: Icon(
                              favorito
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            label: Text(
                              favorito
                                  ? "Favorito"
                                  : "Agregar a favoritos",
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(
                                color: Colors.red,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/details",
                                arguments: widget.movie,
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow,
                            ),
                            label: const Text(
                              "VER",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
    