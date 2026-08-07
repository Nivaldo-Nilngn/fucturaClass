import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class ClassHistoryWidget extends StatelessWidget {
  const ClassHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF161623),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.history, color: Colors.white, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Histórico de Aulas',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ver tudo',
                  style: GoogleFonts.inter(
                    color: bento.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildHistoryItem(
            context,
            title: 'Laços de Repetição (For/While)',
            subtitle: 'Participação ativa nos exercícios práticos.',
            date: '12 Out, 14:00',
            isPresent: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildHistoryItem(
            context,
            title: 'Estruturas Condicionais (If/Else)',
            subtitle: 'Concluiu desafio extra de lógica.',
            date: '05 Out, 14:00',
            isPresent: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildHistoryItem(
            context,
            title: 'Variáveis e Tipos de Dados',
            subtitle: 'Conteúdo introdutório.',
            date: 'FALTA - 28 Set',
            isPresent: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String date,
    required bool isPresent,
  }) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    final iconColor = isPresent ? const Color(0xFF00E1AB) : const Color(0xFFFF6B6B);
    final bgColor = isPresent ? const Color(0xFF00E1AB).withOpacity(0.1) : const Color(0xFFFF6B6B).withOpacity(0.1);
    final icon = isPresent ? Icons.check_circle : Icons.cancel;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: bento.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            date,
            style: GoogleFonts.inter(
              color: isPresent ? Colors.white70 : const Color(0xFFFF6B6B),
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
