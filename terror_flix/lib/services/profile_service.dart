import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {

  static const String fotoKey = "fotoPerfil";

  Future<void> guardarFoto(String ruta) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(fotoKey, ruta);

  }

  Future<String?> obtenerFoto() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(fotoKey);

  }

}