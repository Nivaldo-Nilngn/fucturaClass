import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class StudentShortcutsWidget extends StatelessWidget {
  const StudentShortcutsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return GridView.count(
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: [
            _buildShortcutCard(
              context,
              title: 'Ver Fórum',
              icon: Icons.forum_outlined,
              color: const Color(0xFF00E1AB),
              route: '/forum',
            ),
            _buildShortcutCard(
              context,
              title: 'Ver Exercícios',
              icon: Icons.assignment_outlined,
              color: const Color(0xFF0055FF),
              route: '/exercises',
            ),
            _buildShortcutCard(
              context,
              title: 'Ver Turmas',
              icon: Icons.groups_outlined,
              color: const Color(0xFFFFD700),
              route: '/class-history',
            ),
            _buildShortcutCard(
              context,
              title: 'Ver Rankings',
              icon: Icons.leaderboard_outlined,
              color: const Color(0xFF9D00FF),
              route: '/my-points',
            ),
          ],
        );
      },
    );
  }

  Widget _buildShortcutCard(BuildContext context, {required String title, required IconData icon, required Color color, required String route}) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return InkWell(
      onTap: () {
        context.go(route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: bento.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: GoogleFonts.inter(
                color: bento.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
