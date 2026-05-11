import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'agenda_veterinario_page.dart';

class VeterinariosPage extends StatelessWidget {
  const VeterinariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio Médico'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: ApiService().getVeterinarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final veterinarios = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuestros Especialistas',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contamos con ${veterinarios.length} médicos veterinarios disponibles para atender a tu mascota hoy.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final vet = veterinarios[index] as Map<String, dynamic>;
                      return _VeterinarioCard(vet: vet);
                    },
                    childCount: veterinarios.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VeterinarioCard extends StatelessWidget {
  const _VeterinarioCard({required this.vet});

  final Map<String, dynamic> vet;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgendaVeterinarioPage(veterinario: vet),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Hero(
                tag: 'vet_img_${vet['id_usuario']}',
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(vet['imagen_url'] ?? ''),
                  onBackgroundImageError: (_, __) => {},
                  child: vet['imagen_url'] == null 
                      ? const Icon(Icons.person, size: 35) 
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vet['nombre'] ?? 'Sin nombre',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vet['especialidad'] ?? 'Médico General',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('4.9', style: TextStyle(color: Colors.grey.shade600)),
                        const SizedBox(width: 16),
                        Icon(Icons.event_available, color: Colors.green.shade400, size: 16),
                        const SizedBox(width: 4),
                        const Text('Disponible', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
