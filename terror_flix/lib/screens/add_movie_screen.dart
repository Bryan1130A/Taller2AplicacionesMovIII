import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {

  final TextEditingController titulo = TextEditingController();
  final TextEditingController descripcion = TextEditingController();
  final TextEditingController imagen = TextEditingController();
  final TextEditingController video = TextEditingController();
  final TextEditingController genero = TextEditingController();
  final TextEditingController duracion = TextEditingController();
  final TextEditingController rating =
      TextEditingController(text: "5");

  final DatabaseService databaseService = DatabaseService();

  bool editando = false;
  String id = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final movie = ModalRoute.of(context)
        ?.settings
        .arguments as Map<String, dynamic>?;

    if (movie != null && !editando) {

      editando = true;

      id = movie["id"];

      titulo.text = movie["titulo"] ?? "";
      descripcion.text = movie["descripcion"] ?? "";
      imagen.text = movie["imagen"] ?? "";
      video.text = movie["video"] ?? "";
      genero.text = movie["genero"] ?? "";
      duracion.text = movie["duracion"] ?? "";
      rating.text = movie["rating"].toString();

    }
  }

  @override
  void dispose() {

    titulo.dispose();
    descripcion.dispose();
    imagen.dispose();
    video.dispose();
    genero.dispose();
    duracion.dispose();
    rating.dispose();

    super.dispose();
  }

  Future<void> guardarActualizar() async {

    if (titulo.text.isEmpty ||
        descripcion.text.isEmpty ||
        genero.text.isEmpty ||
        duracion.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Complete todos los campos",
          ),
        ),
      );

      return;
    }
        if (editando) {

      await databaseService.actualizarPelicula(
        id: id,
        titulo: titulo.text.trim(),
        descripcion: descripcion.text.trim(),
        imagen: imagen.text.trim(),
        video: video.text.trim(),
        genero: genero.text.trim(),
        duracion: duracion.text.trim(),
        rating: double.tryParse(rating.text) ?? 5,
      );

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Película actualizada correctamente",
            ),
            backgroundColor: Colors.orange,
          ),
        );

      }

    } else {

      await databaseService.guardarPelicula(
        titulo: titulo.text.trim(),
        descripcion: descripcion.text.trim(),
        imagen: imagen.text.trim(),
        video: video.text.trim(),
        genero: genero.text.trim(),
        duracion: duracion.text.trim(),
        rating: double.tryParse(rating.text) ?? 5,
      );

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Película guardada correctamente",
            ),
            backgroundColor: Colors.green,
          ),
        );

      }

    }

    if (mounted) {
      Navigator.pop(context);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

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

            child: Center(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(25),

                child: Container(

                  width: 500,

                  padding: const EdgeInsets.all(25),

                  decoration: BoxDecoration(

                    color: Colors.black.withOpacity(.70),

                    borderRadius: BorderRadius.circular(25),

                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),

                  ),
                                    child: Column(

                    children: [

                      Icon(
                        editando
                            ? Icons.edit_note
                            : Icons.movie_creation,
                        color: Colors.red,
                        size: 90,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "TERROR FLIX",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        editando
                            ? "Editar Película"
                            : "Agregar Nueva Película",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 30),

                      TextField(
                        controller: titulo,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Título",
                          prefixIcon: Icon(
                            Icons.movie,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: descripcion,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Descripción",
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: genero,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Género",
                          prefixIcon: Icon(
                            Icons.category,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: duracion,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Duración",
                          prefixIcon: Icon(
                            Icons.schedule,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: imagen,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Ruta de la Imagen",
                          hintText: "assets/images/conjuro.jpg",
                          prefixIcon: Icon(
                            Icons.image,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: video,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "URL del Video",
                          hintText:
                              "http://localhost:3000/videos/conjuro.mp4",
                          prefixIcon: Icon(
                            Icons.play_circle_fill,
                            color: Colors.red,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextField(
                        controller: rating,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Rating",
                          prefixIcon: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),
                                            SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: guardarActualizar,
                          icon: Icon(
                            editando
                                ? Icons.edit
                                : Icons.save,
                          ),
                          label: Text(
                            editando
                                ? "ACTUALIZAR PELÍCULA"
                                : "GUARDAR PELÍCULA",
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          "Volver",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
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