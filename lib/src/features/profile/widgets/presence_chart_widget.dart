import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

enum ClassStatus { present, absent, pending, future }

class PresenceChartWidget extends StatelessWidget {
  const PresenceChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    // S1 to S12 mock data
    final classes = [
      ClassStatus.present, // S1
      ClassStatus.present, // S2
      ClassStatus.absent,  // S3
      ClassStatus.present, // S4
      ClassStatus.present, // S5
      ClassStatus.present, // S6
      ClassStatus.present, // S7
      ClassStatus.present, // S8
      ClassStatus.present, // S9
      ClassStatus.present, // S10
      ClassStatus.pending, // S11
      ClassStatus.future,  // S12
    ];

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
                  const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Presença',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'últimas 12 aulas',
                style: GoogleFonts.inter(
                  color: bento.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(12, (index) {
              return _buildClassBox(context, 'S${index + 1}', classes[index]);
            }),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildPendingBanner(context),
        ],
      ),
    );
  }

  Widget _buildClassBox(BuildContext context, String label, ClassStatus status) {
    Color borderColor;
    Color textColor;
    Color bgColor;

    switch (status) {
      case ClassStatus.present:
        borderColor = const Color(0xFF00E1AB).withOpacity(0.5);
        textColor = const Color(0xFF00E1AB);
        bgColor = const Color(0xFF00E1AB).withOpacity(0.1);
        break;
      case ClassStatus.absent:
        borderColor = const Color(0xFFFF6B6B).withOpacity(0.5);
        textColor = const Color(0xFFFF6B6B);
        bgColor = const Color(0xFFFF6B6B).withOpacity(0.1);
        break;
      case ClassStatus.pending:
        borderColor = const Color(0xFFFFD700).withOpacity(0.5);
        textColor = const Color(0xFFFFD700);
        bgColor = const Color(0xFFFFD700).withOpacity(0.1);
        break;
      case ClassStatus.future:
        borderColor = Colors.white24;
        textColor = Colors.white54;
        bgColor = Colors.transparent;
        break;
    }

    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: 1,
          style: status == ClassStatus.future ? BorderStyle.solid : BorderStyle.solid,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPendingBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: const [
                  TextSpan(text: 'Você marcou presença na '),
                  TextSpan(text: 'Aula S11', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' — '),
                  TextSpan(
                    text: 'aguardando confirmação do professor.',
                    style: TextStyle(color: Color(0xFFFFD700)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(
              'pendente',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
