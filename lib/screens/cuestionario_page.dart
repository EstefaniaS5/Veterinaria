import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CuestionarioPage extends StatefulWidget {
  const CuestionarioPage({super.key, required this.perro});

  final Map<String, dynamic> perro;

  @override
  State<CuestionarioPage> createState() => _CuestionarioPageState();
}

class _CuestionarioPageState extends State<CuestionarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _motivoController = TextEditingController();
  final _ocupacionController = TextEditingController();
  final _sectorController = TextEditingController();
  String _tipoHogar = 'Casa';
  bool _tieneExperiencia = false;
  bool _enviando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _motivoController.dispose();
    _ocupacionController.dispose();
    _sectorController.dispose();
    super.dispose();
  }

  Future<void> _enviarCuestionario() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _enviando = true);
      
      final cuestionario = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'perroId': widget.perro['id'],
        'perroNombre': widget.perro['nombre'],
        'perroImagen': widget.perro['imagen'],
        'solicitante': _nombreController.text.trim(),
        'telefono': _telefonoController.text.trim(),
        'ocupacion': _ocupacionController.text.trim(),
        'sector_vivienda': _sectorController.text.trim(),
        'tipoHogar': _tipoHogar,
        'experiencia': _tieneExperiencia,
        'motivo': _motivoController.text.trim(),
        'fecha': DateTime.now().toIso8601String(),
        'estado': 'Pendiente',
      };

      try {
        await ApiService().enviarCuestionario(cuestionario);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuestionario enviado con éxito! Te contactaremos pronto.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar: $e')),
        );
      } finally {
        if (mounted) setState(() => _enviando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario de Adopción'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Estás a un paso de adoptar a ${widget.perro['nombre']}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Por favor responde este breve cuestionario para asegurarnos de que es el hogar ideal.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre Completo',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ocupacionController,
              decoration: const InputDecoration(
                labelText: '¿En qué trabajas?',
                prefixIcon: Icon(Icons.work),
              ),
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sectorController,
              decoration: const InputDecoration(
                labelText: 'Sector en el que vives',
                prefixIcon: Icon(Icons.map),
              ),
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipoHogar,
              decoration: const InputDecoration(
                labelText: 'Tipo de Hogar',
                prefixIcon: Icon(Icons.home),
              ),
              items: const [
                DropdownMenuItem(value: 'Casa', child: Text('Casa')),
                DropdownMenuItem(value: 'Departamento', child: Text('Departamento')),
                DropdownMenuItem(value: 'Finca', child: Text('Finca')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _tipoHogar = val);
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('¿Tienes experiencia con mascotas?'),
              value: _tieneExperiencia,
              onChanged: (val) => setState(() => _tieneExperiencia = val),
              contentPadding: EdgeInsets.zero,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _motivoController,
              decoration: const InputDecoration(
                labelText: '¿Por qué quieres adoptar?',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: _enviando ? null : _enviarCuestionario,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _enviando 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Enviar Solicitud', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
