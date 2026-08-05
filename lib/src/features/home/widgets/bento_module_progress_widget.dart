import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoModuleProgressWidget extends StatelessWidget {
  final HomeState state;

  const BentoModuleProgressWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bento.surfaceContainerLowest, // Or use a gradient like the bento-card CSS class
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.moduleName.toUpperCase(),
                      style: GoogleFonts.jetBrainsMono(
                        color: bento.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.moduleSubtitle,
                      style: GoogleFonts.hankenGrotesk(
                        color: bento.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${state.moduleProgressPercent}%',
                    style: GoogleFonts.hankenGrotesk(
                      color: bento.secondary,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CONCLU\u00cdDO',
                    style: GoogleFonts.jetBrainsMono(
                      color: bento.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: bento.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: state.moduleProgressPercent / 100.0,
              child: Container(
                decoration: BoxDecoration(
                  color: bento.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
