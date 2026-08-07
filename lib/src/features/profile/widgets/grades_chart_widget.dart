import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class GradesChartWidget extends StatelessWidget {
  const GradesChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF161623), // Escuro
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart, color: Color(0xFFFFD700), size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Notas por Módulo',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Média Geral: 8.5',
                style: GoogleFonts.inter(
                  color: bento.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildGradeBar('Mod 1: Intro', 9.5, const Color(0xFF6B7BFF)),
          const SizedBox(height: AppSpacing.md),
          _buildGradeBar('Mod 2: Variáveis', 8.8, const Color(0xFF5A69E6)),
          const SizedBox(height: AppSpacing.md),
          _buildGradeBar('Mod 3: Condicionais', 7.2, const Color(0xFFFFD700)),
          const SizedBox(height: AppSpacing.md),
          _buildGradeBar('Mod 4: Loops', 8.5, const Color(0xFF00E1AB)),
        ],
      ),
    );
  }

  Widget _buildGradeBar(String label, double grade, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: grade / 10,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        SizedBox(
          width: 30,
          child: Text(
            grade.toStringAsFixed(1),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
