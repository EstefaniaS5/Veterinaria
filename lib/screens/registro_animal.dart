import 'package:flutter/material.dart';

import '../services/api_service.dart';

class RegistroAnimalPage extends StatefulWidget {
  const RegistroAnimalPage({super.key});

  @override
  State<RegistroAnimalPage> createState() => _RegistroAnimalPageState();
}

class _RegistroAnimalPageState extends State<RegistroAnimalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _especieController = TextEditingController();
  final _razaController = TextEditingController();
  final _edadController = TextEditingController();
  final _estadoSaludController = TextEditingController();
  final _apiService = ApiService();

  String _sexo = 'Macho';
  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _edadController.dispose();
    _estadoSaludController.dispose();
    super.dispose();
  }

  Future<void> _guardarRegistro() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _mostrarAlerta(
        'Formulario incompleto',
        'Por favor completa todos los campos antes de guardar.',
        esError: true,
      );
      return;
    }

    // Diálogo de confirmación
    final confirmar = await _confirmarAccion(
      titulo: '¿Guardar animal?',
      mensaje:
          '¿Deseas registrar a "${_nombreController.text.trim()}" en el sistema?',
      botonConfirmar: 'Guardar',
    );

    if (!confirmar) return;

    setState(() => _guardando = true);

    final datosAnimal = {
      'nombre': _nombreController.text.trim(),
      'especie': _especieController.text.trim(),
      'raza': _razaController.text.trim(),
      'edad': int.parse(_edadController.text.trim()),
      'estado_salud': _estadoSaludController.text.trim(),
      'sexo': _sexo,
    };

    try {
      final response = await _apiService.registrarAnimal(datosAnimal);
      if (!mounted) return;
      _mostrarExito(response['message']?.toString() ?? 'Animal registrado');
      _formKey.currentState?.reset();
      _nombreController.clear();
      _especieController.clear();
      _razaController.clear();
      _edadController.clear();
      _estadoSaludController.clear();
      setState(() => _sexo = 'Macho');
    } catch (error) {
      if (!mounted) return;
      _mostrarAlerta(
        'Error al guardar',
        'No se pudo guardar el animal. Intenta de nuevo.',
        esError: true,
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  // Snackbar de éxito (verde)
  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Snackbar de error (rojo)
  void _mostrarAlerta(String titulo, String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              esError ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: esError ? Colors.red.shade600 : Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Diálogo de confirmación
  Future<bool> _confirmarAccion({
    required String titulo,
    required String mensaje,
    required String botonConfirmar,
  }) async {
    final resultado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(botonConfirmar),
          ),
        ],
      ),
    );
    return resultado ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Animal'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              Text(
                'Nueva Ficha Médica',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa los datos del paciente para registrarlo en la clínica.',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: _requerido,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _especieController,
                              decoration: const InputDecoration(
                                labelText: 'Especie',
                                hintText: 'Ej: Perro',
                                prefixIcon: Icon(Icons.pets),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: _requerido,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _razaController,
                              decoration: const InputDecoration(
                                labelText: 'Raza',
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              textInputAction: TextInputAction.next,
                              validator: _requerido,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _edadController,
                        decoration: const InputDecoration(
                          labelText: 'Edad (años)',
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: _edadValida,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _estadoSaludController,
                        decoration: const InputDecoration(
                          labelText: 'Estado de salud',
                          prefixIcon: Icon(Icons.health_and_safety_outlined),
                          hintText: 'Ej: Sano, vacunado, en tratamiento...',
                        ),
                        maxLines: 3,
                        validator: _requerido,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Sexo',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'Macho',
                              label: Text('Macho'),
                              icon: Icon(Icons.male),
                            ),
                            ButtonSegment(
                              value: 'Hembra',
                              label: Text('Hembra'),
                              icon: Icon(Icons.female),
                            ),
                          ],
                          selected: {_sexo},
                          onSelectionChanged: (value) {
                            setState(() => _sexo = value.first);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardarRegistro,
                icon: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_guardando ? 'Guardando...' : 'Guardar registro'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String? _requerido(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? _edadValida(String? value) {
    final texto = value?.trim() ?? '';
    final edad = int.tryParse(texto);
    if (edad == null) return 'Ingrese una edad válida (solo números)';
    if (edad < 0 || edad > 80) return 'La edad debe estar entre 0 y 80 años';
    return null;
  }
}
