import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuctura_lms_app/src/features/auth/view_model/auth_view_model.dart';

import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';

class KidsMainShellView extends ConsumerStatefulWidget {
  final Widget child;

  const KidsMainShellView({super.key, required this.child});

  @override
  ConsumerState<KidsMainShellView> createState() => _KidsMainShellViewState();
}

class _KidsMainShellViewState extends ConsumerState<KidsMainShellView> {
  int _currentIndex = 0;

  void _onNavigate(int index, String path) {
    setState(() => _currentIndex = index);
    // context.go(path); // Update when routes exist
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < AppSpacing.mobileBreakpoint;

          if (isMobile) {
            return Column(
              children: [
                Expanded(child: widget.child),
                _buildBottomNavigationBar(),
              ],
            );
          }

          return Row(
            children: [
              _buildSidebar(),
              Expanded(
                child: widget.child,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          right: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(10, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xxl),
          // Logo Area
          Column(
            children: [
              Image.asset('assets/biblia3d.png', height: 60, fit: BoxFit.contain),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Fuctura Kids',
                style: GoogleFonts.nunitoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF7C5800),
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Tech Explorer',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF514532),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxxl),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  isActive: _currentIndex == 0,
                  path: '/kids-home',
                ),
                _buildNavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'My Lessons',
                  index: 1,
                  isActive: _currentIndex == 1,
                  path: '/kids-home',
                ),
                _buildNavItem(
                  icon: Icons.military_tech_rounded,
                  label: 'Awards',
                  index: 2,
                  isActive: _currentIndex == 2,
                  path: '/kids-home',
                ),
                _buildNavItem(
                  icon: Icons.leaderboard_rounded,
                  label: 'Leaderboard',
                  index: 3,
                  isActive: _currentIndex == 3,
                  path: '/kids-home',
                ),
                _buildNavItem(
                  icon: Icons.sports_esports_rounded,
                  label: 'Games',
                  index: 4,
                  isActive: _currentIndex == 4,
                  path: '/kids-home',
                ),
              ],
            ),
          ),
          // Logout Option
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: _buildLogoutItem(context),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Start Quest Button
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD600), Color(0xFFFFB800)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Color(0xFFE6A600),
                    offset: Offset(0, -4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Start Quest',
                  style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF6B4C00),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
    required String path,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: () => _onNavigate(index, path),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFFB800) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFB800).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF6B4C00) : const Color(0xFF514532),
                size: 24,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isActive ? const Color(0xFF6B4C00) : const Color(0xFF514532),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMobileNavItem(Icons.home_rounded, 'Home', 0, '/kids-home'),
          _buildMobileNavItem(Icons.menu_book_rounded, 'Lessons', 1, '/kids-home'),
          _buildMobileNavItem(Icons.military_tech_rounded, 'Awards', 2, '/kids-home'),
          _buildMobileNavItem(Icons.sports_esports_rounded, 'Games', 3, '/kids-home'),
        ],
      ),
    );
  }

  Widget _buildMobileNavItem(IconData icon, String label, int index, String path) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onNavigate(index, path),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFB800) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF6B4C00) : const Color(0xFF514532),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isActive ? const Color(0xFF6B4C00) : const Color(0xFF514532),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(authViewModelProvider.notifier).logout();
        context.go('/');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFFCD2121), // action-red
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              'Sair',
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFCD2121),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
