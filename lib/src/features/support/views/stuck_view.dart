import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class StuckView extends StatelessWidget {
  const StuckView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Scaffold(
      backgroundColor: const Color(0xFF0C1929), // Dark blue header background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dark Header section
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: bento.secondary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'F',
                          style: GoogleFonts.hankenGrotesk(
                            color: bento.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Suporte rápido',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Estou travado',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Selecione o que está acontecendo e vamos resolver juntos.',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            // White body section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F9FC), // surface
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Em que você travou?',
                        style: GoogleFonts.inter(
                          color: bento.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _SupportOptionCard(
                        iconText: '📖',
                        title: 'Não entendi o assunto',
                        bento: bento,
                      ),
                      _SupportOptionCard(
                        iconText: '💡',
                        title: 'Não consegui fazer o exercício',
                        bento: bento,
                      ),
                      _SupportOptionCard(
                        iconText: '🔧',
                        title: 'Meu Eclipse deu erro',
                        bento: bento,
                      ),
                      _SupportOptionCard(
                        iconText: '🎬',
                        title: 'Perdi uma aula',
                        bento: bento,
                      ),
                      _SupportOptionCard(
                        iconText: '💬',
                        title: 'Outro motivo',
                        bento: bento,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportOptionCard extends StatelessWidget {
  final String iconText;
  final String title;
  final BentoColors bento;

  const _SupportOptionCard({
    required this.iconText,
    required this.title,
    required this.bento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bento.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            iconText,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: bento.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
