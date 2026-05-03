import 'package:flutter/material.dart';

import 'api_service.dart';

class BusquedaPage extends StatefulWidget {
  const BusquedaPage({super.key});

  @override
  State<BusquedaPage> createState() => _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> {
  final _nombreController = TextEditingController();
  final _especieController = TextEditingController();
  final _razaController = TextEditingController();
  final _edadMinController = TextEditingController();
  final _edadMaxController = TextEditingController();
  final _apiService = ApiService();

  String _generoFiltro = 'Todos';
  List<dynamic> _resultados = [];
  bool _buscando = false;
  bool _buscado = false; // Para saber si ya se hizo al menos una búsqueda

  @override
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _razaController.dispose();
    _edadMinController.dispose();
    _edadMaxController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    setState(() {
      _buscando = true;
      _buscado = true;
    });

    try {
      final resultados = await _apiService.buscarAnimales(
        nombre: _nombreController.text.trim(),
        especie: _especieController.text.trim(),
        raza: _razaController.text.trim(),
        edadMin: _edadMinController.text.trim().isNotEmpty
            ? int.tryParse(_edadMinController.text.trim())
            : null,
        edadMax: _edadMaxController.text.trim().isNotEmpty
            ? int.tryParse(_edadMaxController.text.trim())
            : null,
        genero: _generoFiltro == 'Todos' ? null : _generoFiltro,
      );

      setState(() => _resultados = resultados);
    } catch (e) {
      setState(() => _resultados = []);
      _mostrarAlerta('No se pudo realizar la búsqueda. Intenta de nuevo.');
    } finally {
      setState(() => _buscando = false);
    }
  }

  void _limpiarFiltros() {
    _nombreController.clear();
    _especieController.clear();
    _razaController.clear();
    _edadMinController.clear();
    _edadMaxController.clear();
    setState(() {
      _generoFiltro = 'Todos';
      _resultados = [];
      _buscado = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar animales'),
        actions: [
          // Botón para limpiar filtros
          if (_buscado)
            TextButton.icon(
              onPressed: _limpiarFiltros,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar'),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Panel de filtros ──
            Container(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Fila 1: Nombre y Especie
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon: Icon(Icons.badge_outlined),
                            isDense: true,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _especieController,
                          decoration: const InputDecoration(
                            labelText: 'Especie',
                            prefixIcon: Icon(Icons.pets),
                            isDense: true,
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Fila 2: Raza
                  TextFormField(
                    controller: _razaController,
                    decoration: const InputDecoration(
                      labelText: 'Raza',
                      prefixIcon: Icon(Icons.category_outlined),
                      isDense: true,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 10),

                  // Fila 3: Edad mínima y máxima
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _edadMinController,
                          decoration: const InputDecoration(
                            labelText: 'Edad min',
                            prefixIcon: Icon(Icons.cake_outlined),
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _edadMaxController,
                          decoration: const InputDecoration(
                            labelText: 'Edad max',
                            prefixIcon: Icon(Icons.cake_outlined),
                            isDense: true,
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Fila 4: Género
                  Row(
                    children: [
                      Text(
                        'Género:',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'Todos', label: Text('Todos')),
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
                          selected: {_generoFiltro},
                          onSelectionChanged: (value) {
                            setState(() => _generoFiltro = value.first);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Botón buscar
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _buscando ? null : _buscar,
                      icon: _buscando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(_buscando ? 'Buscando...' : 'Buscar'),
                    ),
                  ),
                ],
              ),
            ),

            // ── Resultados ──
            Expanded(
              child: _buscando
                  ? const Center(child: CircularProgressIndicator())
                  : !_buscado
                      ? _mensajeCentral(
                          Icons.search,
                          'Ingresa filtros y presiona Buscar',
                        )
                      : _resultados.isEmpty
                          ? _mensajeCentral(
                              Icons.pets,
                              'No se encontraron animales con esos filtros',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _resultados.length,
                              itemBuilder: (context, index) {
                                final animal = _resultados[index];
                                return _TarjetaAnimal(animal: animal);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mensajeCentral(IconData icono, String texto) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            texto,
            style: TextStyle(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de cada animal en los resultados ──
class _TarjetaAnimal extends StatelessWidget {
  const _TarjetaAnimal({required this.animal});

  final dynamic animal;

  @override
  Widget build(BuildContext context) {
    final genero = animal['genero']?.toString() ?? '';
    final esHembra = genero.toLowerCase() == 'hembra';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.pets,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          animal['nombre']?.toString() ?? 'Sin nombre',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${animal['especie']} · ${animal['raza']}',
            ),
            Text(
              '${animal['edad']} años · $genero · ${animal['estadoSalud']}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Icon(
          esHembra ? Icons.female : Icons.male,
          color: esHembra ? Colors.pink.shade300 : Colors.blue.shade300,
        ),
        isThreeLine: true,
      ),
    );
  }
}
