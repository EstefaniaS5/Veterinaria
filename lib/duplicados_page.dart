import 'package:flutter/material.dart';
 
import 'api_service.dart';
 
class DuplicadosPage extends StatefulWidget {
  const DuplicadosPage({super.key});
 
  @override
  State<DuplicadosPage> createState() => _DuplicadosPageState();
}
 
class _DuplicadosPageState extends State<DuplicadosPage> {
  final _apiService = ApiService();
 
  List<Map<String, dynamic>> _duplicados = [];
  bool _cargando = false;
  bool _analizado = false;
 
  Future<void> _analizarDuplicados() async {
    setState(() {
      _cargando = true;
      _analizado = false;
    });
 
    try {
      final duplicados = await _apiService.detectarDuplicados();
      setState(() {
        _duplicados = duplicados;
        _analizado = true;
      });
    } catch (e) {
      _mostrarAlerta('No se pudo analizar. Intenta de nuevo.');
    } finally {
      setState(() => _cargando = false);
    }
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
 
  // Convierte la similitud (0.0 a 1.0) en texto legible
  String _etiquetaSimilitud(double similitud) {
    if (similitud >= 0.95) return 'Muy probable';
    if (similitud >= 0.85) return 'Probable';
    return 'Posible';
  }
 
  Color _colorSimilitud(double similitud) {
    if (similitud >= 0.95) return Colors.red.shade600;
    if (similitud >= 0.85) return Colors.orange.shade600;
    return Colors.amber.shade600;
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detección de duplicados'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Descripción ──
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Como funciona',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'El sistema analiza todos los animales registrados y detecta posibles duplicados comparando nombre y especie. Usa un algoritmo de similitud de texto para encontrar registros que podrían ser el mismo animal.',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
 
              // ── Botón analizar ──
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _cargando ? null : _analizarDuplicados,
                  icon: _cargando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.manage_search),
                  label: Text(_cargando ? 'Analizando...' : 'Analizar duplicados'),
                ),
              ),
              const SizedBox(height: 20),
 
              // ── Resultados ──
              if (_cargando)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (!_analizado)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.content_copy,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Presiona el botón para buscar\nposibles duplicados',
                          style: TextStyle(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else if (_duplicados.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 64, color: Colors.green.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No se encontraron duplicados',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Todos los registros parecen ser únicos',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Text(
                  'Se encontraron ${_duplicados.length} posibles duplicados',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _duplicados.length,
                    itemBuilder: (context, index) {
                      final par = _duplicados[index];
                      final animal1 = par['animal1'];
                      final animal2 = par['animal2'];
                      final similitud = (par['similitud'] as double);
 
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Encabezado con nivel de similitud
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Posible duplicado',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _colorSimilitud(similitud)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: _colorSimilitud(similitud)),
                                    ),
                                    child: Text(
                                      _etiquetaSimilitud(similitud),
                                      style: TextStyle(
                                        color: _colorSimilitud(similitud),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
 
                              // Animal 1
                              _FilaAnimal(
                                label: 'Animal 1',
                                animal: animal1,
                              ),
                              const SizedBox(height: 8),
 
                              // Animal 2
                              _FilaAnimal(
                                label: 'Animal 2',
                                animal: animal2,
                              ),
                              const SizedBox(height: 8),
 
                              // Porcentaje de similitud
                              LinearProgressIndicator(
                                value: similitud,
                                backgroundColor: Colors.grey.shade200,
                                color: _colorSimilitud(similitud),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Similitud: ${(similitud * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
 
// ── Widget para mostrar los datos de un animal ──
class _FilaAnimal extends StatelessWidget {
  const _FilaAnimal({required this.label, required this.animal});
 
  final String label;
  final dynamic animal;
 
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.pets,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${animal['nombre']} (ID: ${animal['id']})',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${animal['especie']} · ${animal['raza']} · ${animal['edad']} años',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
