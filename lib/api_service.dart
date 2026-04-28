import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://tu-api.com"; // Cambia esto por la URL de tu API

  // Método para registrar un nuevo animal
  Future<Map<String, dynamic>> registrarAnimal(Map<String, dynamic> datosAnimal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registro-animal'), // Cambia esta URL según tu API
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(datosAnimal),
    );

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, decodifica el JSON
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar el animal');
    }
  }

  // Método para registrar una cita
  Future<Map<String, dynamic>> registrarCita(Map<String, dynamic> datosCita) async {
    final response = await http.post(
      Uri.parse('$baseUrl/citas'), // Cambia esta URL según tu API
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(datosCita),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar la cita');
    }
  }

  // Método para registrar una adopción
  Future<Map<String, dynamic>> registrarAdopcion(Map<String, dynamic> datosAdopcion) async {
    final response = await http.post(
      Uri.parse('$baseUrl/adopciones'), // Cambia esta URL según tu API
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(datosAdopcion),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar la adopción');
    }
  }
}