import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/user_model.dart';
import '../../auth/view_model/auth_view_model.dart';

class MainShellView extends ConsumerWidget {
  final Widget child;

  const MainShellView({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final isAdmin = user?.isAdmin == true;

    int currentIndex = _calculateSelectedIndex(context, isAdmin);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppSpacing.desktopBreakpoint;

        if (isMobile) {
          final mobileDestinations = _getMobileDestinations(isAdmin);

          return Scaffold(
            body: child,
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E2E),
              ),
              child: NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) => _onItemTapped(index, context, isAdmin),
                backgroundColor: const Color(0xFF1E1E2E),
                indicatorColor: const Color(0xFF00E1AB),
                elevation: 0,
                height: 65,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                destinations: mobileDestinations,
              ),
            ),
          );
        }

        final railDestinations = _getRailDestinations(isAdmin, constraints.maxWidth > 1200);

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) => _onItemTapped(index, context, isAdmin),
                extended: constraints.maxWidth > 1200,
                backgroundColor: const Color(0xFF1E1E2E),
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (constraints.maxWidth > 1200)
                        isAdmin
                            ? Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2ECC71),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'F',
                                      style: GoogleFonts.hankenGrotesk(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Fuctura',
                                    style: GoogleFonts.hankenGrotesk(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              )
                            : SvgPicture.asset(
                                'assets/logoFuctura.svg',
                                height: 32,
                              )
                      else
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isAdmin ? const Color(0xFF2ECC71) : Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'F',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                destinations: railDestinations,
                trailing: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: SizedBox(
                        width: constraints.maxWidth > 1200 ? 256 : 72,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!isAdmin) ...[
                              if (constraints.maxWidth > 1200)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.rocket_launch, size: 16),
                                    label: const Text('Iniciar Desafio Diário', style: TextStyle(fontSize: 12)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF007A33),
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(200, 40),
                                    ),
                                  ),
                                )
                              else
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.rocket_launch, color: Color(0xFF007A33)),
                                ),
                              const SizedBox(height: AppSpacing.md),
                            ],
                            const Divider(indent: 16, endIndent: 16),
                            const SizedBox(height: AppSpacing.sm),
                            if (constraints.maxWidth > 1200) ...[
                              ListTile(
                                leading: Icon(Icons.settings_outlined, size: 20, color: isAdmin ? Colors.white70 : null),
                                title: Text('Configurações', style: TextStyle(fontSize: 14, color: isAdmin ? Colors.white70 : null)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                horizontalTitleGap: 0,
                                onTap: () {},
                              ),
                              ListTile(
                                leading: Icon(Icons.logout_outlined, size: 20, color: isAdmin ? Colors.white70 : null),
                                title: Text('Sair', style: TextStyle(fontSize: 14, color: isAdmin ? Colors.white70 : null)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                horizontalTitleGap: 0,
                                onTap: () {
                                  ref.read(authViewModelProvider.notifier).logout();
                                  context.go('/');
                                },
                              ),
                            ] else ...[
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.settings_outlined, color: isAdmin ? Colors.white70 : null),
                              ),
                              IconButton(
                                onPressed: () {
                                  ref.read(authViewModelProvider.notifier).logout();
                                  context.go('/');
                                },
                                icon: Icon(Icons.logout_outlined, color: isAdmin ? Colors.white70 : null),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(
                child: child,
              ),
            ],
          ),
        );
      },
    );
  }

  List<NavigationDestination> _getMobileDestinations(bool isAdmin) {
    if (isAdmin) {
      return const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined, color: Colors.white60, size: 24),
          selectedIcon: Icon(Icons.dashboard, color: Colors.white, size: 24),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outlined, color: Colors.white60, size: 24),
          selectedIcon: Icon(Icons.people, color: Colors.white, size: 24),
          label: 'Alunos',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined, color: Colors.white60, size: 24),
          selectedIcon: Icon(Icons.school, color: Colors.white, size: 24),
          label: 'Professores',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_books_outlined, color: Colors.white60, size: 24),
          selectedIcon: Icon(Icons.library_books, color: Colors.white, size: 24),
          label: 'Cursos',
        ),
        NavigationDestination(
          icon: Icon(Icons.emoji_events_outlined, color: Colors.white60, size: 24),
          selectedIcon: Icon(Icons.emoji_events, color: Colors.white, size: 24),
          label: 'Desafios',
        ),
      ];
    }

    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined, color: Colors.white60, size: 24),
        selectedIcon: Icon(Icons.home, color: Colors.white, size: 24),
        label: 'Início',
      ),
      NavigationDestination(
        icon: Icon(Icons.bolt_outlined, color: Colors.white60, size: 24),
        selectedIcon: Icon(Icons.bolt, color: Colors.white, size: 24),
        label: 'Praticar',
      ),
      NavigationDestination(
        icon: Icon(Icons.help_outline, color: Colors.white60, size: 24),
        selectedIcon: Icon(Icons.help, color: Colors.white, size: 24),
        label: 'Travei',
      ),
    ];
  }

  List<NavigationRailDestination> _getRailDestinations(bool isAdmin, bool isExtended) {
    if (isAdmin) {
      return const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people_outlined),
          selectedIcon: Icon(Icons.people),
          label: Text('Alunos'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: Text('Professores'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.library_books_outlined),
          selectedIcon: Icon(Icons.library_books),
          label: Text('Cursos'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.emoji_events_outlined),
          selectedIcon: Icon(Icons.emoji_events),
          label: Text('Desafios'),
        ),
      ];
    }

    return const [
      NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: Text('Início'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.bolt_outlined),
        selectedIcon: Icon(Icons.bolt),
        label: Text('Praticar'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.help_outline),
        selectedIcon: Icon(Icons.help),
        label: Text('Travei'),
      ),
    ];
  }

  int _calculateSelectedIndex(BuildContext context, bool isAdmin) {
    final String location = GoRouterState.of(context).uri.path;

    if (isAdmin) {
      if (location.startsWith('/manager/dashboard')) return 0;
      if (location.startsWith('/manager/students')) return 1;
      if (location.startsWith('/manager/professors')) return 2;
      if (location.startsWith('/manager/courses')) return 3;
      if (location.startsWith('/manager/desafios')) return 4;
      if (location.startsWith('/manager')) return 0;
      return 0;
    }

    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/practice')) return 1;
    if (location.startsWith('/stuck')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, bool isAdmin) {
    if (isAdmin) {
      switch (index) {
        case 0:
          context.go('/manager/dashboard');
          break;
        case 1:
          context.go('/manager/students');
          break;
        case 2:
          context.go('/manager/professors');
          break;
        case 3:
          context.go('/manager/courses');
          break;
        case 4:
          context.go('/manager/desafios');
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/practice');
          break;
        case 2:
          context.go('/stuck');
          break;
      }
    }
  }
}