import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/library_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/add_movie_screen.dart';
import 'screens/details_screen.dart';
import 'screens/player_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TerrorFlix());
}

class TerrorFlix extends StatelessWidget {
  const TerrorFlix({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Terror Flix",

      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ),

      initialRoute: "/",

      routes: {
        "/": (context) => const SplashScreen(),

        "/login": (context) => const LoginScreen(),

        "/register": (context) => const RegisterScreen(),

        "/home": (context) => const HomeScreen(),

        "/profile": (context) => const ProfileScreen(),

        "/library": (context) => const LibraryScreen(),

        "/favorites": (context) => const FavoritesScreen(),

        "/add": (context) => const AddMovieScreen(),

        "/details": (context) => const DetailsScreen(),

        "/player": (context) => const PlayerScreen(),
      },
    );
  }
}