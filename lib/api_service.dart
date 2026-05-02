import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService({
    this.baseUrl = 'http://localhost:5000/api',
    this.useMockFallback = true,
  });

  final String baseUrl;
  final bool useMockFallback;

  // ───────────────────────────────────────────
  // ANIMALES
  // ───────────────────────────────────────────

  /// Registrar un animal nuevo
  /// Campos: nombre, especie, raza, edad, genero, estadoSalud
  Future<Map<String, dynamic>> registrarAnimal(
    Map<String, dynamic> datosAnimal,
  ) {
    // Mapear campos del formulario Flutter → campos del backend .NET
    final payload = {
      'nombre': datosAnimal['nombre'],
      'especie': datosAnimal['especie'],
      'raza': datosAnimal['raza'],
      'edad': datosAnimal['edad'],
      'genero': datosAnimal['sexo'],         // Flutter usa 'sexo', .NET usa 'genero'
      'estadoSalud': datosAnimal['estado_salud'], // Flutter usa 'estado_salud', .NET usa 'estadoSalud'
    };
    return _post('/animales', payload, mockMessage: 'Animal registrado');
  }

  /// Obtener todos los animales
  Future<List<dynamic>> obtenerAnimales() {
    return _get('/animales');
  }

  // ───────────────────────────────────────────
  // CITAS
  // ───────────────────────────────────────────

  /// Registrar una cita nueva
  /// Campos: mascotaId, fecha, motivo, responsable, hora
  Future<Map<String, dynamic>> registrarCita(Map<String, dynamic> datosCita) {
    final payload = {
      'mascotaId': datosCita['mascotaId'] ?? 0,
      'fecha': datosCita['fecha'],
      'motivo': datosCita['motivo'],
      'responsable': datosCita['responsable'],
      'hora': datosCita['hora'],
    };
    return _post('/citas', payload, mockMessage: 'Cita agendada');
  }

  /// Obtener todas las citas
  Future<List<dynamic>> obtenerCitas() {
    return _get('/citas');
  }

  // ───────────────────────────────────────────
  // ADOPCIONES
  // ───────────────────────────────────────────

  /// Registrar una adopción nueva
  /// Campos: macotaId (así está en el backend, con typo), adoptante, fechaAdopcion, estado
  Future<Map<String, dynamic>> registrarAdopcion(
    Map<String, dynamic> datosAdopcion,
  ) {
    final payload = {
      'macotaId': datosAdopcion['macotaId'] ?? 0,  // Nota: el backend tiene typo 'macota' sin s
      'adoptante': datosAdopcion['adoptante'],
      'fechaAdopcion': datosAdopcion['fecha_adopcion'], // Flutter usa 'fecha_adopcion'
      'estado': datosAdopcion['estado'],
    };
    return _post('/adopciones', payload, mockMessage: 'Adopción registrada');
  }

  /// Obtener todas las adopciones
  Future<List<dynamic>> obtenerAdopciones() {
    return _get('/adopciones');
  }

  // ───────────────────────────────────────────
  // BÚSQUEDA INTELIGENTE (SCRUM-63)
  // ───────────────────────────────────────────

  /// Buscar animales con filtros opcionales
  /// Filtra localmente desde la lista completa
  Future<List<dynamic>> buscarAnimales({
    String? nombre,
    String? especie,
    String? raza,
    int? edadMin,
    int? edadMax,
    String? genero,
  }) async {
    final todos = await obtenerAnimales();
    return todos.where((a) {
      if (nombre != null && nombre.isNotEmpty) {
        if (!(a['nombre'] as String)
            .toLowerCase()
            .contains(nombre.toLowerCase())) return false;
      }
      if (especie != null && especie.isNotEmpty) {
        if (!(a['especie'] as String)
            .toLowerCase()
            .contains(especie.toLowerCase())) return false;
      }
      if (raza != null && raza.isNotEmpty) {
        if (!(a['raza'] as String)
            .toLowerCase()
            .contains(raza.toLowerCase())) return false;
      }
      if (genero != null && genero.isNotEmpty) {
        if ((a['genero'] as String).toLowerCase() != genero.toLowerCase()) {
          return false;
        }
      }
      if (edadMin != null && (a['edad'] as int) < edadMin) return false;
      if (edadMax != null && (a['edad'] as int) > edadMax) return false;
      return true;
    }).toList();
  }

  // ───────────────────────────────────────────
  // DETECCIÓN DE DUPLICADOS (SCRUM-61)
  // ───────────────────────────────────────────

  /// Detectar posibles animales duplicados comparando nombre + especie
  Future<List<Map<String, dynamic>>> detectarDuplicados() async {
    final todos = await obtenerAnimales();
    final duplicados = <Map<String, dynamic>>[];

    for (int i = 0; i < todos.length; i++) {
      for (int j = i + 1; j < todos.length; j++) {
        final a = todos[i];
        final b = todos[j];
        final similitud = _calcularSimilitud(
          '${a['nombre']} ${a['especie']}'.toLowerCase(),
          '${b['nombre']} ${b['especie']}'.toLowerCase(),
        );
        if (similitud >= 0.75) {
          duplicados.add({'animal1': a, 'animal2': b, 'similitud': similitud});
        }
      }
    }
    return duplicados;
  }

  /// Algoritmo de similitud simple (coeficiente de Dice sobre bigramas)
  double _calcularSimilitud(String a, String b) {
    if (a == b) return 1.0;
    if (a.length < 2 || b.length < 2) return 0.0;

    final bigramasA = _bigramas(a);
    final bigramasB = _bigramas(b);

    int interseccion = 0;
    for (final bigrama in bigramasA) {
      if (bigramasB.contains(bigrama)) interseccion++;
    }

    return (2 * interseccion) / (bigramasA.length + bigramasB.length);
  }

  Set<String> _bigramas(String s) {
    final set = <String>{};
    for (int i = 0; i < s.length - 1; i++) {
      set.add(s.substring(i, i + 2));
    }
    return set;
  }

  // ───────────────────────────────────────────
  // HTTP HELPERS
  // ───────────────────────────────────────────

  Future<List<dynamic>> _get(String path) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl$path'),
            headers: const {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) return decoded;
        return [];
      }
      throw Exception('Error ${response.statusCode}');
    } on Exception {
      if (!useMockFallback) rethrow;
      // Mock data para desarrollo sin backend
      return _mockData(path);
    }
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
        if (decoded is Map<String, dynamic>) return decoded;
        return {'ok': true, 'message': mockMessage, 'data': decoded};
      }
      throw Exception('Error ${response.statusCode}: ${response.body}');
    } on Exception {
      if (!useMockFallback) rethrow;
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return {
        'ok': true,
        'message': '$mockMessage (modo demo)',
        'data': body,
        'mock': true,
      };
    }
  }

  /// Datos de prueba mientras el backend no está disponible
  List<dynamic> _mockData(String path) {
    if (path == '/animales') {
      return [
        {'id': 1, 'nombre': 'Firulais', 'especie': 'Perro', 'raza': 'Labrador', 'edad': 3, 'genero': 'Macho', 'estadoSalud': 'Sano'},
        {'id': 2, 'nombre': 'Mishi', 'especie': 'Gato', 'raza': 'Siamés', 'edad': 2, 'genero': 'Hembra', 'estadoSalud': 'Vacunada'},
        {'id': 3, 'nombre': 'Firulais', 'especie': 'Perro', 'raza': 'Labrador', 'edad': 4, 'genero': 'Macho', 'estadoSalud': 'Sano'},
        {'id': 4, 'nombre': 'Luna', 'especie': 'Gato', 'raza': 'Persa', 'edad': 1, 'genero': 'Hembra', 'estadoSalud': 'En tratamiento'},
        {'id': 5, 'nombre': 'Rocky', 'especie': 'Perro', 'raza': 'Bulldog', 'edad': 5, 'genero': 'Macho', 'estadoSalud': 'Sano'},
      ];
    }
    if (path == '/citas') {
      return [
        {'id': 1, 'mascotaId': 1, 'fecha': '2026-05-10', 'hora': '10:00', 'motivo': 'Vacunación', 'responsable': 'Ana López'},
      ];
    }
    if (path == '/adopciones') {
      return [
        {'id': 1, 'macotaId': 1, 'adoptante': 'Carlos Pérez', 'fechaAdopcion': '2026-04-15', 'estado': 'En proceso'},
      ];
    }
    return [];
  }
}
