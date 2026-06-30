import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference database =
      FirebaseDatabase.instance.ref("peliculas");

  Future<void> guardarPelicula({
    required String titulo,
    required String descripcion,
    required String imagen,
    required String video,
  }) async {
    final nuevaPelicula = database.push();

    await nuevaPelicula.set({
      "titulo": titulo,
      "descripcion": descripcion,
      "imagen": imagen,
      "video": video,
      "rating": 5,
    });
  }

  Stream<DatabaseEvent> obtenerPeliculas() {
    return database.onValue;
  }

  Future<void> eliminarPelicula(String id) async {
    await database.child(id).remove();
  }

  Future<void> actualizarPelicula({
    required String id,
    required String titulo,
    required String descripcion,
    required String imagen,
    required String video,
  }) async {
    await database.child(id).update({
      "titulo": titulo,
      "descripcion": descripcion,
      "imagen": imagen,
      "video": video,
    });
  }
}