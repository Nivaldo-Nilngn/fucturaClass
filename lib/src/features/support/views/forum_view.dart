import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

class ForumView extends StatelessWidget {
  const ForumView({super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fórum da Comunidade',
                      style: GoogleFonts.hankenGrotesk(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tire dúvidas e interaja com outros alunos e professores.',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Tópico'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bento.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            _buildForumTopic(
              context,
              title: 'Erro ao rodar o Flutter Run no Chrome',
              author: 'Maria Silva',
              time: 'Há 2 horas',
              tags: ['Flutter', 'Dúvida'],
              replies: 3,
              isResolved: true,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildForumTopic(
              context,
              title: 'Qual a diferença entre List e Set em Dart?',
              author: 'João Pedro',
              time: 'Há 5 horas',
              tags: ['Dart', 'Conceito'],
              replies: 8,
              isResolved: false,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildForumTopic(
              context,
              title: 'Dica: Como organizar seus repositórios no GitHub',
              author: 'Prof. Carlos',
              time: 'Ontem',
              tags: ['GitHub', 'Dica', 'Carreira'],
              replies: 15,
              isResolved: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForumTopic(
    BuildContext context, {
    required String title,
    required String author,
    required String time,
    required List<String> tags,
    required int replies,
    required bool isResolved,
  }) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bento.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: bento.primary.withOpacity(0.2),
            child: Text(
              author[0],
              style: GoogleFonts.inter(color: bento.primary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isResolved) ...[
                      const Icon(Icons.check_circle, color: Color(0xFF00E1AB), size: 16),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.hankenGrotesk(
                          color: bento.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$author • $time',
                      style: GoogleFonts.inter(
                        color: bento.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: bento.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          color: bento.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            children: [
              Icon(Icons.chat_bubble_outline, color: bento.tertiary, size: 20),
              const SizedBox(height: 4),
              Text(
                '$replies',
                style: GoogleFonts.inter(
                  color: bento.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
