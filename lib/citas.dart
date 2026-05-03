import 'package:flutter/material.dart';

import 'api_service.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
  final _formKey = GlobalKey<FormState>();
  final _mascotaController = TextEditingController();
  final _responsableController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  final _motivoController = TextEditingController();
  final _apiService = ApiService();

  bool _guardando = false;

  @override
  void dispose() {
    _mascotaController.dispose();
    _responsableController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final fecha = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: DateTime(hoy.year + 2),
    );

    if (fecha != null) {
      _fechaController.text =
          '${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora != null && mounted) {
      _horaController.text = hora.format(context);
    }
  }

  Future<void> _guardarCita() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _mostrarAlerta('Por favor completa todos los campos del formulario.');
      return;
    }

    // Diálogo de confirmación
    final confirmar = await _confirmarAccion(
      titulo: '¿Agendar cita?',
      mensaje:
          '¿Confirmas la cita para "${_mascotaController.text.trim()}" el ${_fechaController.text} a las ${_horaController.text}?',
      botonConfirmar: 'Confirmar',
    );

    if (!confirmar) return;

    setState(() => _guardando = true);

    final datosCita = {
      'mascota': _mascotaController.text.trim(),
      'responsable': _responsableController.text.trim(),
      'fecha': _fechaController.text.trim(),
      'hora': _horaController.text.trim(),
      'motivo': _motivoController.text.trim(),
    };

    try {
      final response = await _apiService.registrarCita(datosCita);
      if (!mounted) return;
      _mostrarExito(response['message']?.toString() ?? 'Cita agendada');
      _formKey.currentState?.reset();
      _mascotaController.clear();
      _responsableController.clear();
      _fechaController.clear();
      _horaController.clear();
      _motivoController.clear();
    } catch (error) {
      if (!mounted) return;
      _mostrarAlerta('No se pudo guardar la cita. Intenta de nuevo.');
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
      appBar: AppBar(title: const Text('Agenda de citas')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _mascotaController,
                decoration: const InputDecoration(
                  labelText: 'Mascota',
                  prefixIcon: Icon(Icons.pets),
                ),
                textInputAction: TextInputAction.next,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _responsableController,
                decoration: const InputDecoration(
                  labelText: 'Responsable',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textInputAction: TextInputAction.next,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  hintText: 'Toca para seleccionar fecha',
                ),
                readOnly: true,
                onTap: _seleccionarFecha,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  prefixIcon: Icon(Icons.schedule_outlined),
                  hintText: 'Toca para seleccionar hora',
                ),
                readOnly: true,
                onTap: _seleccionarHora,
                validator: _requerido,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _motivoController,
                decoration: const InputDecoration(
                  labelText: 'Motivo de la cita',
                  prefixIcon: Icon(Icons.description_outlined),
                  hintText: 'Ej: Vacunación, chequeo, consulta...',
                ),
                maxLines: 3,
                validator: _requerido,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardarCita,
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.event_available),
                label: Text(_guardando ? 'Guardando...' : 'Guardar cita'),
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
