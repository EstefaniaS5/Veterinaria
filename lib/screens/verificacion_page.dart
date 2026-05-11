import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VerificacionPage extends StatefulWidget {
  const VerificacionPage({super.key});

  @override
  State<VerificacionPage> createState() => _VerificacionPageState();
}

class _VerificacionPageState extends State<VerificacionPage> {
  late Future<List<dynamic>> _futureCuestionarios;

  @override
  void initState() {
    super.initState();
    _cargarCuestionarios();
  }

  void _cargarCuestionarios() {
    _futureCuestionarios = ApiService().getCuestionariosPendientes();
  }

  Future<void> _actualizarEstado(Map<String, dynamic> form, String estado) async {
    try {
      await ApiService().actualizarCuestionario(form, estado);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(estado == 'Aprobada' ? '¡Adopción aprobada!' : 'Solicitud rechazada'),
          backgroundColor: estado == 'Aprobada' ? Colors.green : Colors.red,
        ),
      );
      setState(() {
        _cargarCuestionarios(); // recargar lista
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de Adopciones'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureCuestionarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final cuestionarios = snapshot.data ?? [];

          if (cuestionarios.isEmpty) {
            return const Center(
              child: Text(
                'No hay cuestionarios pendientes.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cuestionarios.length,
            itemBuilder: (context, index) {
              final form = cuestionarios[index] as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(form['perroImagen'] ?? ''),
                            radius: 24,
                            onBackgroundImageError: (e, s) => {},
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Solicitante: ${form['solicitante']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Para adoptar a: ${form['perroNombre']}',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _DetailRow(icon: Icons.phone, text: form['telefono'] ?? ''),
                      const SizedBox(height: 8),
                      _DetailRow(icon: Icons.work, text: 'Trabaja como: ${form['ocupacion'] ?? 'No especificado'}'),
                      const SizedBox(height: 8),
                      _DetailRow(icon: Icons.map, text: 'Vive en: ${form['sector_vivienda'] ?? 'No especificado'}'),
                      const SizedBox(height: 8),
                      _DetailRow(icon: Icons.home, text: form['tipoHogar'] ?? ''),
                      const SizedBox(height: 8),
                      _DetailRow(
                        icon: Icons.pets,
                        text: (form['experiencia'] == true)
                            ? 'Tiene experiencia previa'
                            : 'Sin experiencia',
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '"${form['motivo']}"',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _actualizarEstado(form, 'Rechazada'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                              icon: const Icon(Icons.close),
                              label: const Text('Rechazar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _actualizarEstado(form, 'Aprobada'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text('Aprobar'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
