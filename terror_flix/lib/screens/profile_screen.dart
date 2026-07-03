import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final User? usuario = FirebaseAuth.instance.currentUser;

  final ImagePicker picker = ImagePicker();

  final ProfileService profileService = ProfileService();

  String? rutaImagen;

  @override
  void initState() {
    super.initState();
    cargarFoto();
  }

  Future<void> cargarFoto() async {

    rutaImagen =
        await profileService.obtenerFoto();

    if (mounted) {
      setState(() {});
    }

  }

  Future<void> seleccionarFoto() async {

    final XFile? imagen = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imagen == null) return;

    await profileService.guardarFoto(
      imagen.path,
    );

    setState(() {

      rutaImagen = imagen.path;

    });

  }

  Future<void> cerrarSesion() async {

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
      (route) => false,
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

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
              color: Colors.black.withOpacity(.85),
            ),

          ),

          SafeArea(

            child: Center(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(25),

                child: Container(

                  width: 430,

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.black.withOpacity(.75),

                    borderRadius: BorderRadius.circular(25),

                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),

                  ),

                  child: Column(

                    children: [
                                            CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.red,
                        backgroundImage: rutaImagen != null
                            ? FileImage(File(rutaImagen!))
                            : null,
                        child: rutaImagen == null
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton.icon(
                        onPressed: seleccionarFoto,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text(
                          "Seleccionar foto",
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "MI PERFIL",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Card(
                        color: Colors.grey.shade900,
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          title: const Text(
                            "Usuario",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          subtitle: Text(
                            usuario?.displayName ?? "Invitado",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Card(
                        color: Colors.grey.shade900,
                        child: ListTile(
                          leading: const Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                          title: const Text(
                            "Correo electrónico",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          subtitle: Text(
                            usuario?.email ?? "No disponible",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      Card(
                        color: Colors.grey.shade900,
                        child: const ListTile(
                          leading: Icon(
                            Icons.movie,
                            color: Colors.red,
                          ),
                          title: Text(
                            "Películas agregadas",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          subtitle: Text(
                            "Próximamente",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),
                                            SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              "/home",
                            );
                          },
                          icon: const Icon(Icons.home),
                          label: const Text(
                            "IR AL CATÁLOGO",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/library",
                            );
                          },
                          icon: const Icon(Icons.library_books),
                          label: const Text(
                            "MI BIBLIOTECA",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: cerrarSesion,
                          icon: const Icon(Icons.logout),
                          label: const Text(
                            "CERRAR SESIÓN",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}