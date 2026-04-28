import 'package:flutter/material.dart';
import 'registro_animal.dart'; // Pantalla de registro animal
import 'citas.dart';          // Pantalla de citas
import 'adopciones.dart';    // Pantalla de adopciones

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenida a Veterinaria'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¡Bienvenido a nuestro sistema de Veterinaria!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registro');
              },
              child: Text('Ir a Registro Animal'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/citas');
              },
              child: Text('Ir a Citas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/adopciones');
              },
              child: Text('Ir a Adopciones'),
            ),
          ],
        ),
      ),
    );
  }
}