import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final DatabaseService databaseService = DatabaseService();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(movie["titulo"]),
      ),
      body: ListView(
        children: [
          Hero(
            tag: movie["titulo"],
            child: Image.network(
              movie["imagen"],
              height: 350,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 350,
                  color: Colors.grey.shade900,
                  child: const Icon(
                    Icons.movie,
                    color: Colors.red,
                    size: 120,
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
                  movie["titulo"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: List.generate(
                    movie["rating"] ?? 5,
                    (index) => const Icon(
                      Icons.star,
                      color: Colors.red,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  movie["descripcion"],
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
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
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text("Editar"),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/add",
                            arguments: movie,
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.delete),
                        label: const Text("Eliminar"),
                        onPressed: () async {
                          final eliminar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Eliminar película"),
                              content: const Text(
                                "¿Desea eliminar esta película?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancelar"),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text("Eliminar"),
                                ),
                              ],
                            ),
                          );

                          if (eliminar == true) {
                            await databaseService.eliminarPelicula(
                              movie["id"],
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Película eliminada correctamente",
                                  ),
                                ),
                              );

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