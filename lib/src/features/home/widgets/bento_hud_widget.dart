import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoHudWidget extends StatelessWidget {
  final HomeState state;

  const BentoHudWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      decoration: BoxDecoration(
        color: bento.surfaceContainerLowest, // or a gradient
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
        children: [
          // Top Border
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: bento.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 600;
                
                final userInfo = Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: bento.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: bento.primary.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        state.initials,
                        style: GoogleFonts.hankenGrotesk(
                          color: bento.onPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.fullName,
                            style: GoogleFonts.hankenGrotesk(
                              color: bento.onSurface,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: bento.secondaryContainer.withOpacity(0.2),
                                  border: Border.all(color: bento.secondaryContainer.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: bento.secondary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      state.badge1,
                                      style: GoogleFonts.jetBrainsMono(
                                        color: bento.onSecondaryContainer,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: bento.tertiaryContainer.withOpacity(0.1),
                                  border: Border.all(color: bento.tertiaryContainer.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  state.badge2,
                                  style: GoogleFonts.jetBrainsMono(
                                    color: bento.tertiary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
                
                final statsRow = IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StatItem(
                        value: '2.847',
                        label: 'PONTOS',
                        color: bento.primary,
                      ),
                      VerticalDivider(
                        width: 32,
                        thickness: 1,
                        color: bento.outlineVariant.withOpacity(0.5),
                      ),
                      _StatItem(
                        value: '${state.streak}',
                        icon: Icons.local_fire_department,
                        label: 'STREAK',
                        color: bento.tertiary,
                      ),
                      VerticalDivider(
                        width: 32,
                        thickness: 1,
                        color: bento.outlineVariant.withOpacity(0.5),
                      ),
                      _StatItem(
                        value: '#${state.rankPosition}',
                        label: 'NA TURMA',
                        color: bento.secondary,
                      ),
                    ],
                  ),
                );
                
                if (isDesktop) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: userInfo),
                      const SizedBox(width: AppSpacing.xl),
                      statsRow,
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Center(child: statsRow),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData? icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: GoogleFonts.hankenGrotesk(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                height: 1,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, color: color, size: 28),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: theme.bento.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
