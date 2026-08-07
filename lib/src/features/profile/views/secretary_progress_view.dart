import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class SecretaryProgressView extends StatelessWidget {
  const SecretaryProgressView({super.key});

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
              'Avanço com a Secretaria',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Acompanhe o status da sua documentação e situação financeira.',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildStatusCard(
              context,
              title: 'Situação Financeira',
              status: 'Regular',
              statusColor: const Color(0xFF00E1AB),
              icon: Icons.attach_money,
              description: 'Todas as suas mensalidades estão em dia.',
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildChecklistCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required String title,
    required String status,
    required Color statusColor,
    required IconData icon,
    required String description,
  }) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: bento.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: statusColor, size: 32),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.hankenGrotesk(
                    color: bento.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: bento.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                color: statusColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: bento.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.folder_shared_outlined, color: bento.primary, size: 28),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Documentação',
                style: GoogleFonts.hankenGrotesk(
                  color: bento.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildCheckItem(context, 'Contrato Assinado', true),
          const SizedBox(height: AppSpacing.md),
          _buildCheckItem(context, 'Cópia do RG/CPF entregue', true),
          const SizedBox(height: AppSpacing.md),
          _buildCheckItem(context, 'Comprovante de Residência entregue', true),
          const SizedBox(height: AppSpacing.md),
          _buildCheckItem(context, 'Foto para crachá (opcional)', false),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String text, bool isChecked) {
    final theme = Theme.of(context);
    final bento = theme.bento;
    final color = isChecked ? const Color(0xFF00E1AB) : bento.outlineVariant;

    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
          color: color,
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          text,
          style: GoogleFonts.inter(
            color: isChecked ? bento.onSurface : bento.onSurfaceVariant,
            fontSize: 16,
            decoration: isChecked ? TextDecoration.lineThrough : null,
            decorationColor: bento.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
