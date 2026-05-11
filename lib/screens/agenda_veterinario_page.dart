import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'citas.dart';

class AgendaVeterinarioPage extends StatelessWidget {
  const AgendaVeterinarioPage({super.key, required this.veterinario});

  final Map<String, dynamic> veterinario;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                veterinario['nombre'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 3.0, color: Colors.black54)],
                ),
              ),
              background: Hero(
                tag: 'vet_img_${veterinario['id_usuario']}',
                child: Image.network(
                  veterinario['imagen_url'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    veterinario['especialidad'] ?? 'Médico General',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Agenda de hoy y próximos días:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A continuación puedes ver los horarios en los que el médico ya tiene citas programadas. Por favor, elige un horario diferente al agendar.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<List<dynamic>>(
            future: ApiService().getCitasVeterinario(veterinario['id_usuario'].toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
                );
              }
              if (snapshot.hasError) {
                return SliverToBoxAdapter(child: Center(child: Text('Error: ${snapshot.error}')));
              }

              final citas = snapshot.data ?? [];

              if (citas.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'No tiene citas agendadas aún. ¡Tiene disponibilidad total!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cita = citas[index] as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.access_time, color: Colors.orange),
                          title: Text('Fecha: ${cita['fecha']} | Hora: ${cita['hora']}'),
                          subtitle: Text('Motivo: ${cita['motivo']} (Ocupado)'),
                        ),
                      );
                    },
                    childCount: citas.length,
                  ),
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CitasPage(veterinario: veterinario),
            ),
          );
        },
        icon: const Icon(Icons.calendar_month),
        label: const Text('Agendar Cita'),
      ),
    );
  }
}
