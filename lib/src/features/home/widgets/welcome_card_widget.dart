import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';

class WelcomeCardWidget extends StatelessWidget {
  final HomeState state;
  final bool showStats;

  const WelcomeCardWidget({super.key, required this.state, this.showStats = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF14142B), // Cor de fundo escura
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: bento.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem-vindo(a) de volta, ${state.firstName}! 👋',
                            style: GoogleFonts.hankenGrotesk(
                              color: bento.onSurface,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            showStats 
                                ? "Você está fazendo um ótimo progresso. Mantenha o ritmo para alcançar o próximo nível!"
                                : "Você está aguardando alocação em uma turma. Em breve, seus pontos e estatísticas aparecerão aqui!",
                            style: GoogleFonts.inter(
                              color: bento.onSurfaceVariant,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (showStats) ...[
                  const SizedBox(height: AppSpacing.lg),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 500;
                      
                      if (isSmallScreen) {
                        return Wrap(
                          spacing: AppSpacing.md,
                          runSpacing: AppSpacing.md,
                          children: [
                            SizedBox(
                              width: (constraints.maxWidth - AppSpacing.md) / 2,
                              child: _StatCard(
                                icon: Icons.local_fire_department_outlined,
                                iconColor: bento.tertiary,
                                value: '${state.streak}',
                                label: 'SEQUÊNCIA ATUAL',
                                sublabel: 'DIAS',
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - AppSpacing.md) / 2,
                              child: _StatCard(
                                icon: Icons.star_outline,
                                iconColor: const Color(0xFFFF6B6B),
                                value: '${state.points}',
                                label: 'XP TOTAL',
                                sublabel: 'XP',
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - AppSpacing.md) / 2,
                              child: _StatCard(
                                icon: Icons.account_balance_wallet_outlined,
                                iconColor: const Color(0xFF4CAF50),
                                value: '0',
                                label: 'MOEDAS',
                                sublabel: 'FC',
                              ),
                            ),
                            SizedBox(
                              width: (constraints.maxWidth - AppSpacing.md) / 2,
                              child: _StatCard(
                                icon: Icons.menu_book_outlined,
                                iconColor: bento.primary,
                                value: '0',
                                label: 'CURSOS',
                                sublabel: '',
                              ),
                            ),
                          ],
                        );
                      }
                      
                      return Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: Icons.local_fire_department_outlined,
                              iconColor: bento.tertiary,
                              value: '${state.streak}',
                              label: 'SEQUÊNCIA\nATUAL',
                              sublabel: 'DIAS',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.star_outline,
                              iconColor: const Color(0xFFFF6B6B),
                              value: '${state.points}',
                              label: 'EXPERIÊNCIA\nTOTAL',
                              sublabel: 'XP',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.account_balance_wallet_outlined,
                              iconColor: const Color(0xFF4CAF50),
                              value: '0',
                              label: 'MOEDAS\nFUCTURA',
                              sublabel: 'FC',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _StatCard(
                              icon: Icons.menu_book_outlined,
                              iconColor: bento.primary,
                              value: '0',
                              label: 'CURSOS\nATIVOS',
                              sublabel: '',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String sublabel;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bento.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.hankenGrotesk(
                    color: bento.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                if (sublabel.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      sublabel,
                      style: GoogleFonts.jetBrainsMono(
                        color: bento.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              color: bento.onSurfaceVariant,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}