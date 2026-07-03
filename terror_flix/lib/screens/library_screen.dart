import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../services/database_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {

  final DatabaseService service = DatabaseService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Biblioteca"),
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      ),

      body: StreamBuilder<DatabaseEvent>(

        stream: service.obtenerPeliculas(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );

          }

          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {

            return const Center(

              child: Text(

                "No existen películas",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),

              ),

            );

          }

          final datos = Map<dynamic, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );

          List<Map<String, dynamic>> peliculas = [];

          datos.forEach((key, value) {

            peliculas.add({

              "id": key,
              "titulo": value["titulo"] ?? "",
              "descripcion": value["descripcion"] ?? "",
              "imagen": value["imagen"] ?? "",
              "video": value["video"] ?? "",
              "rating": value["rating"] ?? 5,

            });

          });

          return ListView.builder(

            padding: const EdgeInsets.all(15),

            itemCount: peliculas.length,

            itemBuilder: (context, index) {

              final movie = peliculas[index];
                            return Card(

                color: Colors.grey.shade900,

                margin: const EdgeInsets.only(bottom: 15),

                elevation: 8,

                child: Padding(

                  padding: const EdgeInsets.all(12),

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      if (movie["imagen"].toString().isNotEmpty)

                        ClipRRect(

                          borderRadius: BorderRadius.circular(10),

                          child: Image.network(

                            movie["imagen"],

                            height: 180,

                            width: double.infinity,

                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 180,
                                color: Colors.black26,
                                child: const Center(
                                  child: Icon(
                                    Icons.movie,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                ),
                              );
                            },

                          ),

                        ),

                      const SizedBox(height: 10),

                      Text(

                        movie["titulo"],

                        style: const TextStyle(

                          color: Colors.white,

                          fontSize: 22,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                      const SizedBox(height: 8),

                      Text(

                        movie["descripcion"],

                        style: const TextStyle(
                          color: Colors.white70,
                        ),

                      ),

                      const SizedBox(height: 10),

                      Row(

                        children: [

                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),

                          const SizedBox(width: 5),

                          Text(

                            movie["rating"].toString(),

                            style: const TextStyle(
                              color: Colors.white,
                            ),

                          ),

                        ],

                      ),

                      const SizedBox(height: 15),

                      Row(

                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,

                        children: [

                          ElevatedButton.icon(

                            onPressed: () {

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                const SnackBar(
                                  content: Text(
                                    "Editar próximamente",
                                  ),
                                ),

                              );

                            },

                            icon: const Icon(Icons.edit),

                            label: const Text("Editar"),

                          ),

                          ElevatedButton.icon(

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),

                            onPressed: () async {

                              await service.eliminarPelicula(
                                movie["id"],
                              );

                            },

                            icon: const Icon(Icons.delete),

                            label: const Text("Eliminar"),

                          ),

                        ],

                      ),

                    ],

                  ),

                ),

              );

            },

          );

        },

      ),

    );

  }

}