import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../services/database_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  final DatabaseService databaseService =
      DatabaseService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        title: const Text(
          "Mis Favoritos",
        ),

        centerTitle: true,

      ),

      body: StreamBuilder<DatabaseEvent>(

        stream: databaseService.obtenerFavoritos(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

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

                "No existen favoritos",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),

              ),

            );

          }

          final datos =
              Map<dynamic, dynamic>.from(
            snapshot.data!.snapshot.value as Map,
          );

          List<Map<String, dynamic>> favoritos = [];
                    datos.forEach((key, value) {

            favoritos.add({

              "id": key,

              "titulo": value["titulo"] ?? "",

              "descripcion": value["descripcion"] ?? "",

              "imagen": value["imagen"] ?? "",

              "video": value["video"] ?? "",

              "genero": value["genero"] ?? "",

              "duracion": value["duracion"] ?? "",

              "rating": value["rating"] ?? 5,

            });

          });

          return GridView.builder(

            padding: const EdgeInsets.all(15),

            itemCount: favoritos.length,

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 3,

              childAspectRatio: .58,

              crossAxisSpacing: 15,

              mainAxisSpacing: 15,

            ),

            itemBuilder: (context, index) {

              final movie = favoritos[index];

              return Card(

                color: Colors.grey.shade900,

                elevation: 10,

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(18),

                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Expanded(

                      flex: 7,

                      child: ClipRRect(

                        borderRadius:
                            const BorderRadius.vertical(

                          top: Radius.circular(18),

                        ),

                        child: Image.asset(

                          movie["imagen"],

                          width: double.infinity,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (_, __, ___) {

                            return Container(

                              color: Colors.black54,

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

                        padding:
                            const EdgeInsets.all(10),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(

                              movie["titulo"],

                              maxLines: 1,

                              overflow:
                                  TextOverflow.ellipsis,

                              style: const TextStyle(

                                color: Colors.white,

                                fontSize: 16,

                                fontWeight:
                                    FontWeight.bold,

                              ),

                            ),

                            const SizedBox(height: 6),

                            Text(

                              movie["genero"],

                              style: const TextStyle(

                                color: Colors.redAccent,

                                fontSize: 12,

                              ),

                            ),

                            const Spacer(),
                                                        Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  Icons.star,
                                  size: 16,
                                  color: i <
                                          (movie["rating"] as num).round()
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/details",
                                    arguments: movie,
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

                            const SizedBox(height: 8),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                onPressed: () async {

                                  await databaseService
                                      .eliminarFavorito(
                                    movie["id"],
                                  );

                                  if (context.mounted) {

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Favorito eliminado",
                                        ),
                                      ),
                                    );

                                  }

                                },
                                icon: const Icon(
                                  Icons.delete,
                                ),
                                label: const Text(
                                  "ELIMINAR",
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),

              );

            },

          );

        },

      ),

    );

  }

}