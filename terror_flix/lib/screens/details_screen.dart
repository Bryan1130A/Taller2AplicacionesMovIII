import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/database_service.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Movie movie =
        ModalRoute.of(context)!.settings.arguments as Movie;

    final DatabaseService databaseService = DatabaseService();

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(movie.titulo),
      ),

      body: ListView(

        children: [

          Hero(

            tag: movie.id,

            child: Image.asset(

              movie.imagen,

              height: 350,

              width: double.infinity,

              fit: BoxFit.cover,

              errorBuilder: (_, __, ___) {

                return Container(

                  height: 350,

                  color: Colors.grey.shade900,

                  child: const Center(

                    child: Icon(

                      Icons.movie,

                      color: Colors.red,

                      size: 120,

                    ),

                  ),

                );

              },

            ),

          ),

          Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  movie.titulo,

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 30,

                    fontWeight: FontWeight.bold,

                  ),

                ),

                const SizedBox(height: 10),

                Row(

                  children: List.generate(

                    movie.rating.round(),

                    (index) => const Icon(

                      Icons.star,

                      color: Colors.red,

                    ),

                  ),

                ),

                const SizedBox(height: 20),

                Text(

                  movie.descripcion,

                  style: const TextStyle(

                    color: Colors.white70,

                    fontSize: 17,

                  ),

                ),

                const SizedBox(height: 15),

                Text(

                  "Género: ${movie.genero}",

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 16,

                  ),

                ),

                const SizedBox(height: 10),

                Text(

                  "Duración: ${movie.duracion}",

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 16,

                  ),

                ),

                const SizedBox(height: 35),

                SizedBox(

                  width: double.infinity,

                  child: ElevatedButton.icon(

                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.red.shade700,

                      foregroundColor: Colors.white,

                    ),

                    icon: const Icon(Icons.play_arrow),

                    label: const Text("VER PELÍCULA"),

                    onPressed: () {

                      Navigator.pushNamed(

                        context,

                        "/player",

                        arguments: movie,

                      );

                    },

                  ),

                ),

                const SizedBox(height: 15),

                Row(

                  children: [

                    Expanded(

                      child: ElevatedButton.icon(

                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.orange,

                          foregroundColor: Colors.white,

                        ),

                        icon: const Icon(Icons.edit),

                        label: const Text("Editar"),

                        onPressed: () {

                          Navigator.pushNamed(

                            context,

                            "/add",

                            arguments: {

                              "id": movie.id.toString(),
                              "titulo": movie.titulo,
                              "descripcion": movie.descripcion,
                              "imagen": movie.imagen,
                              "video": movie.video,
                              "genero": movie.genero,
                              "duracion": movie.duracion,
                              "rating": movie.rating,

                            },

                          );

                        },

                      ),

                    ),

                    const SizedBox(width: 15),

                    Expanded(

                      child: ElevatedButton.icon(

                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.red,

                          foregroundColor: Colors.white,

                        ),

                        icon: const Icon(Icons.delete),

                        label: const Text("Eliminar"),

                        onPressed: () async {

                          final eliminar = await showDialog<bool>(

                            context: context,

                            builder: (context) {

                              return AlertDialog(

                                title: const Text(
                                  "Eliminar película",
                                ),

                                content: const Text(
                                  "¿Desea eliminar esta película?",
                                ),

                                actions: [

                                  TextButton(

                                    onPressed: () {

                                      Navigator.pop(
                                        context,
                                        false,
                                      );

                                    },

                                    child: const Text("Cancelar"),

                                  ),

                                  ElevatedButton(

                                    onPressed: () {

                                      Navigator.pop(
                                        context,
                                        true,
                                      );

                                    },

                                    child: const Text("Eliminar"),

                                  ),

                                ],

                              );

                            },

                          );

                          if (eliminar == true) {

                            await databaseService.eliminarPelicula(
                              movie.id.toString(),
                            );

                            if (context.mounted) {

                              Navigator.pop(context);

                            }

                          }

                        },

                      ),

                    ),

                  ],

                ),

              ],

            ),

          ),

        ],

      ),

    );

  }

}