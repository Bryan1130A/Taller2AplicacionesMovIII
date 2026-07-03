import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController buscar =
      TextEditingController();

  final MovieService movieService =
      MovieService();

  List<Movie> peliculas = [];

  List<Movie> filtradas = [];

  bool cargando = true;

  @override
  void initState() {
    super.initState();

    cargarPeliculas();
  }

  Future<void> cargarPeliculas() async {

    peliculas =
        await movieService.obtenerPeliculas();

    filtradas = peliculas;

    setState(() {

      cargando = false;

    });

  }

  void buscarPeliculas(String texto){

    setState(() {

      filtradas = peliculas.where((movie){

        return movie.titulo
            .toLowerCase()
            .contains(
              texto.toLowerCase(),
            );

      }).toList();

    });

  }

  @override
  void dispose() {

    buscar.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: Colors.black,

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor: Colors.red,

        foregroundColor: Colors.white,

        icon: const Icon(Icons.add),

        label: const Text("Agregar"),

        onPressed: (){

          Navigator.pushNamed(
            context,
            "/add",
          );

        },

      ),
            body: Stack(

        children: [

          Positioned.fill(

            child: Image.asset(
              "assets/images/fondo.jpg",
              fit: BoxFit.cover,
            ),

          ),

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

                  Icons.movie_filter,

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

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: TextField(

                    controller: buscar,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

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

                      enabledBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(30),

                        borderSide:
                            const BorderSide(
                          color: Colors.red,
                        ),

                      ),

                      focusedBorder:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(30),

                        borderSide:
                            const BorderSide(

                          color: Colors.red,

                          width: 2,

                        ),

                      ),

                    ),

                    onChanged: buscarPeliculas,

                  ),

                ),

                const SizedBox(height: 20),
                                Expanded(

                  child: cargando

                      ? const Center(

                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),

                        )

                      : filtradas.isEmpty

                          ? const Center(

                              child: Text(

                                "No se encontraron películas",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),

                              ),

                            )

                          : GridView.builder(

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

        type: BottomNavigationBarType.fixed,

        onTap: (index) async {

          switch (index) {

            case 0:
              break;

            case 1:

              Navigator.pushNamed(
                context,
                "/library",
              );

              break;

            case 2:

              Navigator.pushNamed(
                context,
                "/add",
              );

              break;

            case 3:

              Navigator.pushNamed(
                context,
                "/profile",
              );

              break;

            case 4:

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
            icon: Icon(Icons.library_books),
            label: "Biblioteca",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Agregar",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
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