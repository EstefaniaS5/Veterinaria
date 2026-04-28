import 'package:flutter/material.dart';

import 'api_service.dart';

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
      return;
    }

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
      _mostrarMensaje(response['message']?.toString() ?? 'Animal registrado');
      _formKey.currentState?.reset();
      _nombreController.clear();
      _especieController.clear();
      _razaController.clear();
      _edadController.clear();
      _estadoSaludController.clear();
      setState(() => _sexo = 'Macho');
    } catch (error) {
      if (!mounted) return;
      _mostrarMensaje('No se pudo guardar el animal: $error');
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro animal')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 14),
              TextFormField(
                controller: _especieController,
                decoration: const InputDecoration(
                  labelText: 'Especie',
                  hintText: 'Perro, gato, conejo...',
                  prefixIcon: Icon(Icons.pets),
                ),
                textInputAction: TextInputAction.next,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _razaController,
                decoration: const InputDecoration(
                  labelText: 'Raza',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                textInputAction: TextInputAction.next,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _edadValida,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _estadoSaludController,
                decoration: const InputDecoration(
                  labelText: 'Estado de salud',
                  prefixIcon: Icon(Icons.health_and_safety_outlined),
                ),
                maxLines: 3,
                validator: _requerido,
              ),
              const SizedBox(height: 18),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Macho', label: Text('Macho')),
                  ButtonSegment(value: 'Hembra', label: Text('Hembra')),
                ],
                selected: {_sexo},
                onSelectionChanged: (value) {
                  setState(() => _sexo = value.first);
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardarRegistro,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: Text(_guardando ? 'Guardando...' : 'Guardar registro'),
              ),
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
    if (edad == null) {
      return 'Ingrese una edad válida';
    }
    if (edad < 0 || edad > 80) {
      return 'Ingrese una edad entre 0 y 80';
    }
    return null;
  }
}
