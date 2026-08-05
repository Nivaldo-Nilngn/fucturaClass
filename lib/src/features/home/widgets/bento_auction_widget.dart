import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoAuctionWidget extends StatelessWidget {
  final HomeState state;

  const BentoAuctionWidget({super.key, required this.state});

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
                  children: [
                    Icon(Icons.gavel, color: bento.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Leilão de prêmios',
                      style: GoogleFonts.hankenGrotesk(
                        color: bento.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                ...state.auctions.map((auction) => _AuctionItem(auction: auction, bento: bento)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuctionItem extends StatelessWidget {
  final AuctionItem auction;
  final BentoColors bento;

  const _AuctionItem({required this.auction, required this.bento});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bento.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: auction.isWinning ? bento.secondary.withOpacity(0.3) : bento.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auction.title,
                      style: GoogleFonts.inter(
                        color: bento.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'lance mínimo ${auction.minBid} · inc. +${auction.increment}',
                      style: GoogleFonts.jetBrainsMono(
                        color: bento.onSurfaceVariant,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: auction.isWinning ? bento.surfaceVariant : bento.errorContainer.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: auction.isWinning ? bento.outlineVariant.withOpacity(0.5) : bento.error.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: auction.isWinning ? bento.onSurfaceVariant : bento.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      auction.timeLeft,
                      style: GoogleFonts.jetBrainsMono(
                        color: auction.isWinning ? bento.onSurfaceVariant : bento.error,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${auction.currentBid} pts',
                    style: GoogleFonts.jetBrainsMono(
                      color: auction.isWinning ? bento.secondary : bento.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (auction.isWinning) ...[
                        Icon(Icons.check_circle, color: bento.secondary, size: 12),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        auction.topBidder,
                        style: GoogleFonts.jetBrainsMono(
                          color: auction.isWinning ? bento.secondary.withOpacity(0.8) : bento.onSurfaceVariant,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              if (auction.isWinning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: bento.secondaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: bento.secondary.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Você está\nganhando',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jetBrainsMono(
                      color: bento.secondary,
                      fontSize: 10,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bento.primary,
                    foregroundColor: bento.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Dar lance',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
