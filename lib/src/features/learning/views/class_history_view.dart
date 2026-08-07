import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class ClassHistoryView extends StatelessWidget {
  const ClassHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histórico de Turmas',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Visualize seu progresso e os certificados das turmas concluídas.',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildClassCard(
              context,
              title: 'Desenvolvimento Flutter Expert',
              status: 'Em Andamento',
              statusColor: bento.primary,
              progress: 0.6,
              period: 'Maio 2026 - Presente',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildClassCard(
              context,
              title: 'Lógica de Programação com Python',
              status: 'Concluído',
              statusColor: const Color(0xFF00E1AB),
              progress: 1.0,
              period: 'Janeiro 2026 - Abril 2026',
              hasCertificate: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildClassCard(
              context,
              title: 'Introdução ao Git e GitHub',
              status: 'Concluído',
              statusColor: const Color(0xFF00E1AB),
              progress: 1.0,
              period: 'Novembro 2025 - Dezembro 2025',
              hasCertificate: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(
    BuildContext context, {
    required String title,
    required String status,
    required Color statusColor,
    required double progress,
    required String period,
    bool hasCertificate = false,
  }) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bento.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.hankenGrotesk(
                    color: bento.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            period,
            style: GoogleFonts.inter(
              color: bento.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (hasCertificate) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(color: Colors.white10),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.workspace_premium),
                label: const Text('Ver Certificado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E1AB),
                  foregroundColor: const Color(0xFF14142B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
