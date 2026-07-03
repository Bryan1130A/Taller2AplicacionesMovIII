import 'package:firebase_database/firebase_database.dart';

class DatabaseService {

  final DatabaseReference peliculas =
      FirebaseDatabase.instance.ref("peliculas");

  final DatabaseReference favoritos =
      FirebaseDatabase.instance.ref("favoritos");

  // ==========================
  // PELÍCULAS
  // ==========================

  Future<void> guardarPelicula({
    required String titulo,
    required String descripcion,
    required String imagen,
    required String video,
    required String genero,
    required String duracion,
    required double rating,
  }) async {

    try {

      final nueva = peliculas.push();

      await nueva.set({

        "titulo": titulo,
        "descripcion": descripcion,
        "imagen": imagen,
        "video": video,
        "genero": genero,
        "duracion": duracion,
        "rating": rating,

      });

    } catch (e) {

      throw Exception("Error al guardar película: $e");

    }

  }

  Stream<DatabaseEvent> obtenerPeliculas() {
    return peliculas.onValue;
  }

  Future<void> eliminarPelicula(String id) async {

    try {

      await peliculas.child(id).remove();

    } catch (e) {

      throw Exception("Error al eliminar película: $e");

    }

  }

  Future<void> actualizarPelicula({
    required String id,
    required String titulo,
    required String descripcion,
    required String imagen,
    required String video,
    required String genero,
    required String duracion,
    required double rating,
  }) async {

    try {

      await peliculas.child(id).update({

        "titulo": titulo,
        "descripcion": descripcion,
        "imagen": imagen,
        "video": video,
        "genero": genero,
        "duracion": duracion,
        "rating": rating,

      });

    } catch (e) {

      throw Exception("Error al actualizar película: $e");

    }

  }

  // ==========================
  // FAVORITOS
  // ==========================

  Future<void> agregarFavorito({
    required String titulo,
    required String descripcion,
    required String imagen,
    required String video,
    required String genero,
    required String duracion,
    required double rating,
  }) async {

    try {

      final nuevo = favoritos.push();

      await nuevo.set({

        "titulo": titulo,
        "descripcion": descripcion,
        "imagen": imagen,
        "video": video,
        "genero": genero,
        "duracion": duracion,
        "rating": rating,

      });

    } catch (e) {

      throw Exception("Error al agregar favorito: $e");

    }

  }

  Stream<DatabaseEvent> obtenerFavoritos() {
    return favoritos.onValue;
  }

  Future<void> eliminarFavorito(String id) async {

    try {

      await favoritos.child(id).remove();

    } catch (e) {

      throw Exception("Error al eliminar favorito: $e");

    }

  }

}