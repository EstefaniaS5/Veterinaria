import 'package:flutter/material.dart';
import 'registro_animal.dart'; // Importa el archivo de la pantalla de registro animal

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
      home: RegistroAnimalPage(), // Aquí configuramos RegistroAnimalPage como la pantalla inicial
      routes: {
        '/registro': (context) => RegistroAnimalPage(),
        // Si en el futuro necesitas otras rutas, las puedes agregar aquí.
      },
    );
  }
}