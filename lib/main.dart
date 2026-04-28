import 'package:flutter/material.dart';
import 'inicio.dart';          // Pantalla de inicio
import 'registro_animal.dart'; // Pantalla de registro animal
import 'citas.dart';           // Pantalla de citas
import 'adopciones.dart';      // Pantalla de adopciones

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veterinaria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InicioPage(), // Pantalla de inicio
      routes: {
        '/inicio': (context) => InicioPage(),
        '/registro': (context) => RegistroAnimalPage(),
        '/citas': (context) => CitasPage(),
        '/adopciones': (context) => AdopcionesPage(),
      },
    );
  }
}