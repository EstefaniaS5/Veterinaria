import 'package:flutter/material.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _nombreReportanteController = TextEditingController();

  String _tipoReporte = 'Abandono';
  String _prioridad = 'Normal';
  bool _guardando = false;

  // Lista local de reportes guardados (mientras no hay backend)
  final List<Map<String, dynamic>> _reportes = [];

  @override
  void dispose() {
    _descripcionController.dispose();
    _ubicacionController.dispose();
    _nombreReportanteController.dispose();
    super.dispose();
  }

  Future<void> _guardarReporte() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _mostrarAlerta('Por favor completa todos los campos del formulario.');
      return;
    }

    final confirmar = await _confirmarAccion(
      titulo: '¿Enviar reporte?',
      mensaje: _prioridad == 'Urgente'
          ? 'Este reporte será marcado como URGENTE. ¿Confirmas?'
          : '¿Confirmas el envío del reporte de "${_tipoReporte}"?',
      botonConfirmar: 'Enviar',
    );

    if (!confirmar) return;

    setState(() => _guardando = true);

    await Future<void>.delayed(const Duration(milliseconds: 600));

    final nuevoReporte = {
      'tipo': _tipoReporte,
      'descripcion': _descripcionController.text.trim(),
      'ubicacion': _ubicacionController.text.trim(),
      'reportante': _nombreReportanteController.text.trim(),
      'prioridad': _prioridad,
      'fecha': DateTime.now().toIso8601String().substring(0, 10),
      'estado': 'Nuevo',
    };

    setState(() {
      _reportes.insert(0, nuevoReporte);
      _guardando = false;
    });

    _mostrarExito(
      _prioridad == 'Urgente'
          ? 'Reporte urgente enviado'
          : 'Reporte enviado correctamente',
    );

    _formKey.currentState?.reset();
    _descripcionController.clear();
    _ubicacionController.clear();
    _nombreReportanteController.clear();
    setState(() {
      _tipoReporte = 'Abandono';
      _prioridad = 'Normal';
    });
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

  Color _colorPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Urgente':
        return Colors.red.shade600;
      case 'Alta':
        return Colors.orange.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  IconData _iconoPrioridad(String prioridad) {
    switch (prioridad) {
      case 'Urgente':
        return Icons.warning_amber_rounded;
      case 'Alta':
        return Icons.priority_high;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportes')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // ── Formulario ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo reporte',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Tipo de reporte
                      DropdownButtonFormField<String>(
                        value: _tipoReporte,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de reporte',
                          prefixIcon: Icon(Icons.report_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Abandono', child: Text('Abandono')),
                          DropdownMenuItem(value: 'Maltrato', child: Text('Maltrato')),
                          DropdownMenuItem(value: 'Animal herido', child: Text('Animal herido')),
                          DropdownMenuItem(value: 'Animal perdido', child: Text('Animal perdido')),
                          DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _tipoReporte = value);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Prioridad
                      Text(
                        'Prioridad',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: [
                          ButtonSegment(
                            value: 'Normal',
                            label: const Text('Normal'),
                            icon: Icon(
                              Icons.info_outline,
                              color: _prioridad == 'Normal'
                                  ? Colors.blue.shade600
                                  : null,
                            ),
                          ),
                          ButtonSegment(
                            value: 'Alta',
                            label: const Text('Alta'),
                            icon: Icon(
                              Icons.priority_high,
                              color: _prioridad == 'Alta'
                                  ? Colors.orange.shade600
                                  : null,
                            ),
                          ),
                          ButtonSegment(
                            value: 'Urgente',
                            label: const Text('Urgente'),
                            icon: Icon(
                              Icons.warning_amber_rounded,
                              color: _prioridad == 'Urgente'
                                  ? Colors.red.shade600
                                  : null,
                            ),
                          ),
                        ],
                        selected: {_prioridad},
                        onSelectionChanged: (value) {
                          setState(() => _prioridad = value.first);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Descripción
                      TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                          prefixIcon: Icon(Icons.description_outlined),
                          hintText: 'Describe la situación del animal...',
                        ),
                        maxLines: 3,
                        validator: _requerido,
                      ),
                      const SizedBox(height: 14),

                      // Ubicación
                      TextFormField(
                        controller: _ubicacionController,
                        decoration: const InputDecoration(
                          labelText: 'Ubicación',
                          prefixIcon: Icon(Icons.location_on_outlined),
                          hintText: 'Calle, barrio, referencia...',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: _requerido,
                      ),
                      const SizedBox(height: 14),

                      // Nombre reportante
                      TextFormField(
                        controller: _nombreReportanteController,
                        decoration: const InputDecoration(
                          labelText: 'Tu nombre',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.done,
                        validator: _requerido,
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _guardando ? null : _guardarReporte,
                          icon: _guardando
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send_outlined),
                          label: Text(_guardando ? 'Enviando...' : 'Enviar reporte'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Lista de reportes enviados ──
            if (_reportes.isNotEmpty) ...[
              Text(
                'Reportes enviados (${_reportes.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              ..._reportes.map(
                (reporte) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _colorPrioridad(reporte['prioridad']),
                      child: Icon(
                        _iconoPrioridad(reporte['prioridad']),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      reporte['tipo'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reporte['descripcion'], maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(
                          '${reporte['ubicacion']} · ${reporte['fecha']}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _colorPrioridad(reporte['prioridad']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _colorPrioridad(reporte['prioridad']),
                        ),
                      ),
                      child: Text(
                        reporte['prioridad'],
                        style: TextStyle(
                          color: _colorPrioridad(reporte['prioridad']),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            ],
          ],
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
