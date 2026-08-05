import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoRankingWidget extends StatelessWidget {
  final HomeState state;

  const BentoRankingWidget({super.key, required this.state});

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
              color: bento.secondary, // or primary depending on the HTML reference
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.emoji_events, color: bento.secondary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Ranking',
                          style: GoogleFonts.hankenGrotesk(
                            color: bento.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: bento.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: bento.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'TURMA',
                              style: GoogleFonts.jetBrainsMono(
                                color: bento.onPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: Text(
                              'GERAL',
                              style: GoogleFonts.jetBrainsMono(
                                color: bento.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...state.ranking.map((user) => _RankingItem(user: user, bento: bento)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankingItem extends StatelessWidget {
  final RankingUser user;
  final BentoColors bento;

  const _RankingItem({required this.user, required this.bento});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: user.isCurrentUser ? bento.primaryContainer.withOpacity(0.1) : bento.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: user.isCurrentUser ? bento.primary.withOpacity(0.2) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${user.rank}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(
                      color: user.rank == 1
                          ? bento.tertiary
                          : user.isCurrentUser
                              ? bento.primary
                              : bento.outline,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    user.name,
                    style: GoogleFonts.inter(
                      color: user.isCurrentUser ? bento.primary : bento.onSurface,
                      fontSize: 14,
                      fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (user.isCurrentUser) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: bento.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Você',
                      style: GoogleFonts.jetBrainsMono(
                        color: bento.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${user.points} pts',
            style: GoogleFonts.jetBrainsMono(
              color: user.isCurrentUser ? bento.primary : bento.secondary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
