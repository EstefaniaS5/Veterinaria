import 'package:flutter/material.dart';
 
class InicioPage extends StatelessWidget {
  const InicioPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema veterinario'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Gestión de animales, citas y adopciones',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Frontend listo para registrar información y conectarse al backend del equipo cuando los endpoints estén disponibles.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _MenuOption(
              icon: Icons.pets,
              title: 'Registro animal',
              subtitle: 'Crear ficha con datos básicos, salud y sexo.',
              route: '/registro',
            ),
            _MenuOption(
              icon: Icons.event_available,
              title: 'Citas',
              subtitle: 'Agendar atención veterinaria con fecha, hora y motivo.',
              route: '/citas',
            ),
            _MenuOption(
              icon: Icons.volunteer_activism,
              title: 'Adopciones',
              subtitle: 'Registrar estado y fecha del proceso de adopción.',
              route: '/adopciones',
            ),
            // SCRUM-62: Reportes urgentes
            _MenuOption(
              icon: Icons.report_problem_outlined,
              title: 'Reportes',
              subtitle: 'Reportar abandono, maltrato o animal en riesgo.',
              route: '/reportes',
            ),
            // SCRUM-63: Búsqueda inteligente
            _MenuOption(
              icon: Icons.search,
              title: 'Buscar animales',
              subtitle: 'Filtra por nombre, especie, raza, edad y género.',
              route: '/busqueda',
            ),
            // SCRUM-61: Detección de duplicados
            _MenuOption(
              icon: Icons.content_copy,
              title: 'Duplicados',
              subtitle: 'Detecta animales registrados más de una vez.',
              route: '/duplicados',
            ),
          ],
        ),
      ),
    );
  }
}
 
class _MenuOption extends StatelessWidget {
  const _MenuOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
 
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
 
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}

