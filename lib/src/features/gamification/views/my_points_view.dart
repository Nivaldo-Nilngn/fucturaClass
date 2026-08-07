import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class MyPointsView extends StatelessWidget {
  const MyPointsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meus Pontos',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Acompanhe seu nível e histórico de XP ganhos na plataforma.',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildLevelCard(context),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Histórico Recente',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildHistoryList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0055FF), Color(0xFF00E1AB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.stars, color: Color(0xFFFFD700), size: 64),
          ),
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nível 12',
                  style: GoogleFonts.hankenGrotesk(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mestre do Código',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.8,
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '12.500 / 15.000 XP',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      decoration: BoxDecoration(
        color: bento.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _buildHistoryItem(
            context,
            title: 'Desafio Python Concluído',
            date: 'Hoje, 14:30',
            xp: '+50 XP',
            icon: Icons.code,
          ),
          const Divider(height: 1, color: Colors.white10),
          _buildHistoryItem(
            context,
            title: 'Presença Confirmada',
            date: 'Ontem, 19:00',
            xp: '+10 XP',
            icon: Icons.check_circle_outline,
          ),
          const Divider(height: 1, color: Colors.white10),
          _buildHistoryItem(
            context,
            title: 'Perfil Completado',
            date: '05 de Agosto',
            xp: '+100 XP',
            icon: Icons.person_outline,
          ),
          const Divider(height: 1, color: Colors.white10),
          _buildHistoryItem(
            context,
            title: 'Login Diário',
            date: '05 de Agosto',
            xp: '+5 XP',
            icon: Icons.login,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String title,
    required String date,
    required String xp,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0055FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF00E1AB)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: bento.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    color: bento.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            xp,
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF00E1AB),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
