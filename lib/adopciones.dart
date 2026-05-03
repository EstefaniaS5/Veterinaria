import 'package:flutter/material.dart';

import 'api_service.dart';

class AdopcionesPage extends StatefulWidget {
  const AdopcionesPage({super.key});

  @override
  State<AdopcionesPage> createState() => _AdopcionesPageState();
}

class _AdopcionesPageState extends State<AdopcionesPage> {
  final _formKey = GlobalKey<FormState>();
  final _animalController = TextEditingController();
  final _adoptanteController = TextEditingController();
  final _fechaAdopcionController = TextEditingController();
  final _apiService = ApiService();

  String _estadoAdopcion = 'En proceso';
  bool _guardando = false;

  @override
  void dispose() {
    _animalController.dispose();
    _adoptanteController.dispose();
    _fechaAdopcionController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 1),
    );

    if (fecha != null) {
      _fechaAdopcionController.text =
          '${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _guardarAdopcion() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _mostrarAlerta('Por favor completa todos los campos del formulario.');
      return;
    }

    // Diálogo de confirmación
    final confirmar = await _confirmarAccion(
      titulo: '¿Registrar adopción?',
      mensaje:
          '¿Confirmas la adopción de "${_animalController.text.trim()}" por "${_adoptanteController.text.trim()}"?',
      botonConfirmar: 'Registrar',
    );

    if (!confirmar) return;

    setState(() => _guardando = true);

    final datosAdopcion = {
      'animal': _animalController.text.trim(),
      'adoptante': _adoptanteController.text.trim(),
      'fecha_adopcion': _fechaAdopcionController.text.trim(),
      'estado': _estadoAdopcion,
    };

    try {
      final response = await _apiService.registrarAdopcion(datosAdopcion);
      if (!mounted) return;
      _mostrarExito(response['message']?.toString() ?? 'Adopción registrada');
      _formKey.currentState?.reset();
      _animalController.clear();
      _adoptanteController.clear();
      _fechaAdopcionController.clear();
      setState(() => _estadoAdopcion = 'En proceso');
    } catch (error) {
      if (!mounted) return;
      _mostrarAlerta('No se pudo registrar la adopción. Intenta de nuevo.');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

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

  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

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
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de adopción')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _animalController,
                decoration: const InputDecoration(
                  labelText: 'Animal',
                  prefixIcon: Icon(Icons.pets),
                  hintText: 'Nombre del animal a adoptar',
                ),
                textInputAction: TextInputAction.next,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _adoptanteController,
                decoration: const InputDecoration(
                  labelText: 'Adoptante',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Nombre completo del adoptante',
                ),
                textInputAction: TextInputAction.next,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _fechaAdopcionController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de adopción',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  hintText: 'Toca para seleccionar fecha',
                ),
                readOnly: true,
                onTap: _seleccionarFecha,
                validator: _requerido,
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: _estadoAdopcion,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  prefixIcon: Icon(Icons.fact_check_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'En proceso',
                    child: Text('En proceso'),
                  ),
                  DropdownMenuItem(value: 'Aprobada', child: Text('Aprobada')),
                  DropdownMenuItem(
                    value: 'Rechazada',
                    child: Text('Rechazada'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _estadoAdopcion = value);
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardarAdopcion,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.volunteer_activism),
                label: Text(
                    _guardando ? 'Guardando...' : 'Guardar adopción'),
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
}
