import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';

class StudentNoticesWidget extends StatelessWidget {
  final HomeState state;

  const StudentNoticesWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bento.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.campaign_outlined, color: bento.tertiary, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Mural de Avisos',
                  style: GoogleFonts.hankenGrotesk(
                    color: bento.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                _buildNoticeItem(
                  context,
                  title: 'Prazo do Desafio Python encerra amanhã!',
                  date: 'Há 2 horas',
                  icon: Icons.timer_outlined,
                  color: const Color(0xFFFF6B6B),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildNoticeItem(
                  context,
                  title: 'Nova Aula Magna confirmada para Sexta-feira.',
                  date: 'Há 1 dia',
                  icon: Icons.event_available_outlined,
                  color: bento.primary,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildNoticeItem(
                  context,
                  title: 'Seja bem-vindo ao novo sistema da Fuctura LMS.',
                  date: 'Há 3 dias',
                  icon: Icons.info_outline,
                  color: bento.tertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(BuildContext context, {required String title, required String date, required IconData icon, required Color color}) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: GoogleFonts.inter(
                  color: bento.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
