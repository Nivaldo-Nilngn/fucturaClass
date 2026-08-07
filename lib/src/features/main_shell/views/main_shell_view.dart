import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/user_model.dart';
import '../../auth/view_model/auth_view_model.dart';

import '../components/constants.dart';
import '../components/menu.dart';
import '../components/btm_nav_item.dart';
import '../components/menu_btn.dart';
import '../components/side_bar.dart';
import '../components/rive_utils.dart';

class MainShellView extends ConsumerWidget {
  final Widget child;

  const MainShellView({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final isAdmin = user?.isAdmin == true;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppSpacing.desktopBreakpoint;

        if (isMobile) {
          return _AnimatedMobileShell(child: child, isAdmin: isAdmin);
        }

        int currentIndex = _calculateSelectedIndex(context, isAdmin);
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
                        SvgPicture.asset(
                          'assets/logoFucturaColor.svg',
                          height: 32,
                        )
                      else
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isAdmin ? const Color(0xFF0055FF) : Theme.of(context).colorScheme.primary,
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
                                onTap: () async {
                                  await ref.read(authViewModelProvider.notifier).logout();
                                  if (context.mounted) context.go('/');
                                },
                              ),
                            ] else ...[
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.settings_outlined, color: isAdmin ? Colors.white70 : null),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await ref.read(authViewModelProvider.notifier).logout();
                                  if (context.mounted) context.go('/');
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
        label: Text('Home'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.groups_outlined),
        selectedIcon: Icon(Icons.groups),
        label: Text('Minha Turma'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.assignment_outlined),
        selectedIcon: Icon(Icons.assignment),
        label: Text('Exercícios'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.timer_outlined),
        selectedIcon: Icon(Icons.timer),
        label: Text('Desafios'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.gavel_outlined),
        selectedIcon: Icon(Icons.gavel),
        label: Text('Leilões'),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.receipt_long_outlined),
        selectedIcon: Icon(Icons.receipt_long),
        label: Text('Extrato'),
      ),
    ];
  }

  static int _calculateSelectedIndex(BuildContext context, bool isAdmin) {
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

    if (location.startsWith('/home') || location == '/') return 0;
    // For now we map everything else to 0 or leave placeholder routes
    if (location.startsWith('/exercises')) return 1;
    if (location.startsWith('/forum')) return 2;
    return 0;
  }

  static void _onItemTapped(int index, BuildContext context, bool isAdmin) {
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
        case 5:
          _showAvisosDialog(context);
          break;
      }
    } else {
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/exercises');
          break;
        case 2:
          context.go('/forum');
          break;
        case 4:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Acessando Leilões...')));
          break;
        case 5:
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Acessando Extrato de Pontos...')));
          break;
      }
    }
  }

  static void _showAvisosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF14142B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF464555)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Avisos do Sistema',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE3E0F6),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: const Icon(Icons.close, color: Color(0xFFC7C4D7), size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildAvisoItem('Hoje, 10:00', 'Manutenção programada no servidor de banco de dados.', const Color(0xFFFFDF9E)),
                const SizedBox(height: AppSpacing.md),
                _buildAvisoItem('Ontem, 15:30', 'Novo módulo de "Desafios" ativado com sucesso.', const Color(0xFF00E1AB)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildAvisoItem(String time, String message, Color color) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7)),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFE3E0F6)),
          ),
        ],
      ),
    );
  }
}

class _AnimatedMobileShell extends StatefulWidget {
  final Widget child;
  final bool isAdmin;

  const _AnimatedMobileShell({required this.child, required this.isAdmin});

  @override
  State<_AnimatedMobileShell> createState() => _AnimatedMobileShellState();
}

class _AnimatedMobileShellState extends State<_AnimatedMobileShell> with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  late Menu selectedBottonNav;
  late List<Menu> navItems;

  late SMIBool isMenuOpenInput;
  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    navItems = widget.isAdmin ? adminBottomNavItems : userBottomNavItems;
    selectedBottonNav = navItems.first;

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int currentIndex = MainShellView._calculateSelectedIndex(context, widget.isAdmin);
    if (currentIndex >= 0 && currentIndex < navItems.length) {
      selectedBottonNav = navItems[currentIndex];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
      int index = navItems.indexOf(menu);
      MainShellView._onItemTapped(index, context, widget.isAdmin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const SideBar(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: isSideBarOpen ? const BorderRadius.all(Radius.circular(24)) : BorderRadius.zero,
                  child: widget.child,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(() {
                  isSideBarOpen = !isSideBarOpen;
                });
              },
              riveOnInit: (artboard) {
                final controller = StateMachineController.fromArtboard(artboard, "State Machine");
                artboard.addController(controller!);
                isMenuOpenInput = controller.findInput<bool>("isOpen") as SMIBool;
                isMenuOpenInput.value = true;
              },
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            right: isSideBarOpen ? -100 : 0,
            top: 16,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // TODO: Navigate to Ranking
                      },
                      icon: const Icon(Icons.workspace_premium_outlined, color: Color(0xFFC7C4D7), size: 28),
                    ),
                    const SizedBox(width: 4),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            MainShellView._showAvisosDialog(context);
                          },
                          icon: const Icon(Icons.notifications_outlined, color: Color(0xFFC7C4D7), size: 28),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFB3B3), // Corzinha rosa/avermelhada para o ponto
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor2.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...List.generate(
                  navItems.length,
                  (index) {
                    Menu navBar = navItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        if (navBar.rive != null && navBar.rive!.status != null) {
                          RiveUtils.chnageSMIBoolState(navBar.rive!.status!);
                        }
                        updateSelectedBtmNav(navBar);
                      },
                      riveOnInit: (artboard) {
                        if (navBar.rive != null) {
                          navBar.rive!.status = RiveUtils.getRiveInput(artboard, stateMachineName: navBar.rive!.stateMachineName);
                        }
                      },
                      selectedNav: selectedBottonNav,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}