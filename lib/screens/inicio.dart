import 'package:flutter/material.dart';
import '../services/api_service.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _pendientesCount = 0;

  @override
  void initState() {
    super.initState();
    _cargarBadges();
  }

  Future<void> _cargarBadges() async {
    try {
      final cuestionarios = await ApiService().getCuestionariosPendientes();
      if (mounted) {
        setState(() {
          _pendientesCount = cuestionarios.length;
        });
      }
    } catch (e) {
      // Ignorar errores de carga de badges por ahora
    }
  }

  void _navigate(String route) async {
    await Navigator.pushNamed(context, route);
    // Refrescar al volver para actualizar posibles badges
    _cargarBadges();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Sistema Veterinario',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -20,
                      child: Icon(
                        Icons.pets,
                        size: 180,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Panel de Control',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selecciona una opción para gestionar la clínica o adoptar.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Módulo de Adopciones
                _SectionTitle(title: 'Centro de Adopción', icon: Icons.volunteer_activism, color: Colors.pink.shade300),
                const SizedBox(height: 12),
                _AnimatedMenuOption(
                  icon: Icons.home,
                  title: 'Refugio',
                  subtitle: 'Conoce a los perritos disponibles.',
                  onTap: () => _navigate('/refugio'),
                  delay: 0,
                  iconColor: Colors.orange.shade400,
                ),
                _AnimatedMenuOption(
                  icon: Icons.admin_panel_settings,
                  title: 'Verificar Solicitudes',
                  subtitle: 'Aprobar o rechazar cuestionarios.',
                  onTap: () => _navigate('/verificacion'),
                  delay: 100,
                  badgeCount: _pendientesCount,
                  iconColor: Colors.blue.shade400,
                ),
                _AnimatedMenuOption(
                  icon: Icons.check_circle,
                  title: 'Perritos de Salida',
                  subtitle: 'Historial de adopciones exitosas.',
                  onTap: () => _navigate('/salida'),
                  delay: 200,
                  iconColor: Colors.green.shade400,
                ),
                
                const SizedBox(height: 24),
                
                // Módulo Clínico Original
                _SectionTitle(title: 'Gestión Clínica', icon: Icons.local_hospital, color: Colors.teal.shade300),
                const SizedBox(height: 12),
                _AnimatedMenuOption(
                  icon: Icons.pets,
                  title: 'Registro animal',
                  subtitle: 'Crear ficha con datos básicos y salud.',
                  onTap: () => _navigate('/registro'),
                  delay: 300,
                ),
                _AnimatedMenuOption(
                  icon: Icons.medical_services,
                  title: 'Directorio Médico',
                  subtitle: 'Agendar citas y ver disponibilidad.',
                  onTap: () => _navigate('/veterinarios'),
                  delay: 400,
                ),
                _AnimatedMenuOption(
                  icon: Icons.assignment,
                  title: 'Adopciones Internas',
                  subtitle: 'Proceso formal de adopciones (clínica).',
                  onTap: () => _navigate('/adopciones'),
                  delay: 500,
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionTitle({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _AnimatedMenuOption extends StatelessWidget {
  const _AnimatedMenuOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.delay,
    this.badgeCount = 0,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int delay;
  final int badgeCount;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final themeColor = iconColor ?? Theme.of(context).colorScheme.primary;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        icon,
                        color: themeColor,
                        size: 32,
                      ),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            badgeCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
