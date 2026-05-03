import 'package:flutter/material.dart';

import 'adopciones.dart';
import 'citas.dart';
import 'inicio.dart';
import 'registro_animal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veterinaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E7C7B)),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      initialRoute: '/inicio',
      routes: {
        '/inicio': (context) => const InicioPage(),
        '/registro': (context) => const RegistroAnimalPage(),
        '/citas': (context) => const CitasPage(),
        '/adopciones': (context) => const AdopcionesPage(),
      },
    );
  }
}
