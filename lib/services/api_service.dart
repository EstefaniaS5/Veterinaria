import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Singleton para mantener los datos mock en memoria si la DB falla
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'http://localhost:3000/api';
  final bool useMockFallback = true;

  // --- Endpoints Originales ---
  Future<Map<String, dynamic>> registrarAnimal(Map<String, dynamic> datosAnimal) {
    return _post('/animales', datosAnimal, mockMessage: 'Animal registrado');
  }

  Future<Map<String, dynamic>> registrarCita(Map<String, dynamic> datosCita) async {
    try {
      final response = await _post('/citas', datosCita, mockMessage: 'Cita agendada');
      return response;
    } catch (e) {
      if (useMockFallback) {
        _mockCitas.add(datosCita);
        return {'ok': true, 'message': 'Cita agendada (Local)'};
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> registrarAdopcion(Map<String, dynamic> datosAdopcion) {
    return _post('/adopciones', datosAdopcion, mockMessage: 'Adopción registrada');
  }

  // --- Nuevos Endpoints (Veterinarios y Citas) ---
  Future<List<dynamic>> getVeterinarios() async {
    try {
      final response = await _get('/usuarios?rol=veterinario');
      return response;
    } catch (e) {
      if (useMockFallback) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return _mockVeterinarios;
      }
      rethrow;
    }
  }

  Future<List<dynamic>> getCitasVeterinario(String idVeterinario) async {
    try {
      final response = await _get('/citas?id_veterinario=$idVeterinario');
      return response;
    } catch (e) {
      if (useMockFallback) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return _mockCitas.where((c) => c['id_veterinario'] == idVeterinario).toList();
      }
      rethrow;
    }
  }

  // --- Nuevos Endpoints (Refugio, Cuestionarios, Salida) ---
  
  Future<List<dynamic>> getAnimalesDisponibles() async {
    try {
      final response = await _get('/animales?estado=Disponible');
      return response;
    } catch (e) {
      if (useMockFallback) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return _mockAnimales;
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> enviarCuestionario(Map<String, dynamic> datos) async {
    try {
      final response = await _post('/cuestionarios', datos, mockMessage: 'Cuestionario enviado');
      return response;
    } catch (e) {
      if (useMockFallback) {
        _mockCuestionarios.add(datos);
        return {'ok': true, 'message': 'Cuestionario enviado (Local)'};
      }
      rethrow;
    }
  }

  Future<List<dynamic>> getCuestionariosPendientes() async {
    try {
      final response = await _get('/cuestionarios?estado=Pendiente');
      return response;
    } catch (e) {
      if (useMockFallback) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return _mockCuestionarios;
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> actualizarCuestionario(Map<String, dynamic> form, String estado) async {
    try {
      final response = await _put('/cuestionarios/${form['id']}', {'estado': estado}, mockMessage: 'Cuestionario $estado');
      return response;
    } catch (e) {
      if (useMockFallback) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (estado == 'Aprobada') {
          _mockCuestionarios.removeWhere((c) => c['id'] == form['id']);
          _mockSalidas.add({
            'perro': {
               'nombre': form['perroNombre'],
               'imagen': form['perroImagen'],
            },
            'adoptante': form,
            'fecha': DateTime.now().toIso8601String(),
          });
          _mockAnimales.removeWhere((a) => a['id'] == form['perroId']);
        } else {
          _mockCuestionarios.removeWhere((c) => c['id'] == form['id']);
        }
        return {'ok': true, 'message': 'Actualizado (Local)'};
      }
      rethrow;
    }
  }

  Future<List<dynamic>> getAdopcionesSalida() async {
    try {
      final response = await _get('/adopciones/salida');
      return response;
    } catch (e) {
      if (useMockFallback) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return _mockSalidas;
      }
      rethrow;
    }
  }

  // --- Helpers HTTP ---
  Future<dynamic> _get(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path')).timeout(const Duration(seconds: 3));
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception('Error GET ${response.statusCode}');
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body, {required String mockMessage}) async {
    try {
      final response = await http
          .post(Uri.parse('$baseUrl$path'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {'ok': true, 'message': mockMessage};
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return {'ok': true, 'message': mockMessage, 'data': decoded};
      }
      throw Exception('Error POST ${response.statusCode}: ${response.body}');
    } on Exception {
      if (!useMockFallback) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return {'ok': true, 'message': '$mockMessage en modo demo', 'data': body, 'mock': true};
    }
  }

  Future<Map<String, dynamic>> _put(String path, Map<String, dynamic> body, {required String mockMessage}) async {
    try {
      final response = await http
          .put(Uri.parse('$baseUrl$path'), headers: {'Content-Type': 'application/json'}, body: jsonEncode(body))
          .timeout(const Duration(seconds: 3));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return {'ok': true, 'message': mockMessage};
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return {'ok': true, 'message': mockMessage, 'data': decoded};
      }
      throw Exception('Error PUT ${response.statusCode}: ${response.body}');
    } on Exception {
      if (!useMockFallback) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return {'ok': true, 'message': '$mockMessage en modo demo', 'data': body, 'mock': true};
    }
  }

  // --- MOCK DATA PARA CUANDO NO HAY BASE DE DATOS ---
  final List<Map<String, dynamic>> _mockAnimales = [
    {
      'id': '1',
      'nombre': 'Max',
      'raza': 'Golden Retriever',
      'edad': '2 años',
      'imagen': 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&q=80&w=400',
      'descripcion': 'Juguetón y amigable. Rescatado de la calle.',
      'sexo': 'Macho',
      'estado': 'Disponible',
    },
    {
      'id': '2',
      'nombre': 'Luna',
      'raza': 'Mestizo',
      'edad': '8 meses',
      'imagen': 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&q=80&w=400',
      'descripcion': 'Curiosa y llena de energía. Necesita mucho amor.',
      'sexo': 'Hembra',
      'estado': 'Disponible',
    },
    {
      'id': '3',
      'nombre': 'Rocky',
      'raza': 'Bulldog',
      'edad': '3 años',
      'imagen': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&q=80&w=400',
      'descripcion': 'Tranquilo y cariñoso. Le encanta dormir en el sofá.',
      'sexo': 'Macho',
      'estado': 'Disponible',
    },
  ];

  final List<Map<String, dynamic>> _mockCuestionarios = [];
  final List<Map<String, dynamic>> _mockSalidas = [];

  final List<Map<String, dynamic>> _mockVeterinarios = [
    {
      'id_usuario': '2',
      'nombre': 'Dr. Carlos Perez',
      'especialidad': 'Cirugía General',
      'imagen_url': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?auto=format&fit=crop&q=80&w=400',
    },
    {
      'id_usuario': '3',
      'nombre': 'Dra. Sofia Mendez',
      'especialidad': 'Medicina Interna',
      'imagen_url': 'https://images.unsplash.com/photo-1594824436951-7f12bc4175de?auto=format&fit=crop&q=80&w=400',
    },
  ];

  final List<Map<String, dynamic>> _mockCitas = [
    {
      'id_veterinario': '2',
      'fecha': '2026-05-15',
      'hora': '10:00',
      'mascota': 'Firulais',
      'motivo': 'Chequeo',
    },
    {
      'id_veterinario': '3',
      'fecha': '2026-05-15',
      'hora': '14:30',
      'mascota': 'Mishi',
      'motivo': 'Vacunación',
    },
  ];
}
