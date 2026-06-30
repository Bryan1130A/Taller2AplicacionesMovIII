import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../services/database_service.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController buscar = TextEditingController();

  final DatabaseService service = DatabaseService();

  @override
  void dispose() {
    buscar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Agregar"),
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
      ),

      body: Stack(
        children: [

          /// Fondo
          Positioned.fill(
            child: Image.asset(
              "assets/images/fondo.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Oscurecer fondo
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(.82),
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 15),

                const Icon(
                  Icons.movie_filter_rounded,
                  color: Colors.red,
                  size: 60,
                ),

                const SizedBox(height: 10),

                const Text(
                  "TERROR FLIX",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Las mejores películas de terror",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20),

                  child: TextField(
                    controller: buscar,

                    style:
                        const TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      hintText: "Buscar película...",

                      hintStyle: const TextStyle(
                        color: Colors.white60,
                      ),

                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.red,
                      ),

                      filled: true,

                      fillColor: Colors.black54,

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30),

                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30),

                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                    ),

                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: StreamBuilder<DatabaseEvent>(
                    stream: service.obtenerPeliculas(),

                    builder: (context, snapshot) {

                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child:
                              CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.snapshot.value ==
                              null) {
                        return const Center(
                          child: Text(
                            "No existen películas",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }

                      final datos =
                          Map<dynamic, dynamic>.from(
                        snapshot.data!.snapshot.value
                            as Map,
                      );

                      List<Map<String, dynamic>>
                          peliculas = [];

                      datos.forEach((key, value) {
                        peliculas.add({
                          "id": key,
                          "titulo":
                              value["titulo"] ?? "",
                          "descripcion":
                              value["descripcion"] ?? "",
                          "imagen":
                              value["imagen"] ?? "",
                          "video":
                              value["video"] ?? "",
                          "rating":
                              value["rating"] ?? 5,
                        });
                      });

                      final filtradas =
                          peliculas.where((movie) {
                        return movie["titulo"]
                            .toLowerCase()
                            .contains(
                              buscar.text
                                  .toLowerCase(),
                            );
                      }).toList();
                                            return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),

                        itemCount: filtradas.length,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: .58,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                        ),

                        itemBuilder: (context, index) {
                          return MovieCard(
                            movie: filtradas[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white60,
        currentIndex: 0,

        onTap: (index) async {
          switch (index) {
            case 0:
              break;

            case 1:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Favoritos próximamente",
                  ),
                ),
              );
              break;

            case 2:
              await FirebaseAuth.instance.signOut();

              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => false,
                );
              }
              break;
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favoritos",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Salir",
          ),
        ],
      ),
    );
  }
}