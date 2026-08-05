import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoNextClassWidget extends StatelessWidget {
  final HomeState state;

  const BentoNextClassWidget({super.key, required this.state});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.play_circle, color: bento.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Próxima Aula',
                          style: GoogleFonts.hankenGrotesk(
                            color: bento.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: bento.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${state.nextClassDate}, ${state.nextClassTime}',
                        style: GoogleFonts.jetBrainsMono(
                          color: bento.onSurfaceVariant,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  state.nextClassTopic,
                  style: GoogleFonts.hankenGrotesk(
                    color: bento.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.nextClassDescription,
                  style: GoogleFonts.inter(
                    color: bento.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: bento.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
                  ),
                  child: Text(
                    state.nextClassCodeSnippet,
                    style: GoogleFonts.jetBrainsMono(
                      color: bento.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bento.primary,
                    foregroundColor: bento.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Acessar Material',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


