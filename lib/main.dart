import 'package:flutter/material.dart';

import 'screens/adopciones.dart';
import 'screens/citas.dart';
import 'screens/inicio.dart';
import 'screens/registro_animal.dart';
import 'screens/refugio_page.dart';
import 'screens/salida_page.dart';
import 'screens/verificacion_page.dart';
import 'screens/veterinarios_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00B4D8); // Vibrant cyan/teal
    const secondaryColor = Color(0xFF0077B6); // Deep blue
    
    return MaterialApp(
      title: 'Veterinaria',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          surfaceTint: Colors.white,
          surface: const Color(0xFFF8F9FA),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Default, but ensures consistency
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: secondaryColor,
          titleTextStyle: TextStyle(
            color: secondaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red.shade300, width: 1),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIconColor: primaryColor,
        ),
      ),
      initialRoute: '/inicio',
      routes: {
        '/inicio': (context) => const InicioPage(),
        '/registro': (context) => const RegistroAnimalPage(),
        '/citas': (context) => const CitasPage(),
        '/adopciones': (context) => const AdopcionesPage(),
        '/refugio': (context) => const RefugioPage(),
        '/salida': (context) => const SalidaPage(),
        '/verificacion': (context) => const VerificacionPage(),
        '/veterinarios': (context) => const VeterinariosPage(),
      },
    );
  }
}
