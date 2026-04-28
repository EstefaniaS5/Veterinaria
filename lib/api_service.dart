import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  ApiService({
    this.baseUrl = 'http://localhost:3000/api',
    this.useMockFallback = true,
  });

  final String baseUrl;
  final bool useMockFallback;

  Future<Map<String, dynamic>> registrarAnimal(
    Map<String, dynamic> datosAnimal,
  ) {
    return _post('/animales', datosAnimal, mockMessage: 'Animal registrado');
  }

  Future<Map<String, dynamic>> registrarCita(Map<String, dynamic> datosCita) {
    return _post('/citas', datosCita, mockMessage: 'Cita agendada');
  }

  Future<Map<String, dynamic>> registrarAdopcion(
    Map<String, dynamic> datosAdopcion,
  ) {
    return _post(
      '/adopciones',
      datosAdopcion,
      mockMessage: 'Adopción registrada',
    );
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    required String mockMessage,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return {'ok': true, 'message': mockMessage};
        }

        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        return {'ok': true, 'message': mockMessage, 'data': decoded};
      }

      throw Exception('Error ${response.statusCode}: ${response.body}');
    } on Exception {
      if (!useMockFallback) {
        rethrow;
      }

      await Future<void>.delayed(const Duration(milliseconds: 500));
      return {
        'ok': true,
        'message': '$mockMessage en modo demo',
        'data': body,
        'mock': true,
      };
    }
  }
}
