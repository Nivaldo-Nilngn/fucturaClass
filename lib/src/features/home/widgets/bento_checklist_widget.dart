import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoChecklistWidget extends StatelessWidget {
  final HomeState state;

  const BentoChecklistWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      decoration: BoxDecoration(
        color: bento.surfaceContainerLowest,
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
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: bento.secondary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Checklist do conteúdo',
                  style: GoogleFonts.hankenGrotesk(
                    color: bento.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...state.checklist.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  if (index > 0)
                    Divider(color: bento.outlineVariant.withOpacity(0.3), height: 16),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: item.isCompleted ? bento.secondary : bento.surface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: item.isCompleted ? bento.secondary : bento.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: item.isCompleted
                            ? Icon(Icons.check, color: bento.onSecondary, size: 16)
                            : null,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.inter(
                            color: item.isCompleted ? bento.onSurfaceVariant : bento.onSurface,
                            fontSize: 16,
                            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                            fontWeight: item.isCompleted ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: bento.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: bento.tertiary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'marcado por Você é definitivo â€” o professor acompanha pelo seu perfil',
                      style: GoogleFonts.jetBrainsMono(
                        color: bento.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
