import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class ExercisesListView extends StatelessWidget {
  const ExercisesListView({super.key});

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
              'Exercícios Práticos',
              style: GoogleFonts.hankenGrotesk(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Teste seus conhecimentos resolvendo os desafios propostos pelos professores.',
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildExerciseCard(
              context,
              title: 'Variáveis e Tipos de Dados em Python',
              module: 'Módulo 1 - Lógica Básica',
              difficulty: 'Fácil',
              difficultyColor: const Color(0xFF00E1AB),
              points: 50,
              isCompleted: false,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildExerciseCard(
              context,
              title: 'Estruturas de Repetição (For/While)',
              module: 'Módulo 2 - Controle de Fluxo',
              difficulty: 'Médio',
              difficultyColor: const Color(0xFFFFD700),
              points: 100,
              isCompleted: false,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildExerciseCard(
              context,
              title: 'Manipulação de Arrays (Listas)',
              module: 'Módulo 3 - Estruturas de Dados',
              difficulty: 'Difícil',
              difficultyColor: const Color(0xFFFF6B6B),
              points: 200,
              isCompleted: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context, {
    required String title,
    required String module,
    required String difficulty,
    required Color difficultyColor,
    required int points,
    required bool isCompleted,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF00E1AB).withOpacity(0.1) : bento.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.code,
              color: isCompleted ? const Color(0xFF00E1AB) : bento.primary,
              size: 28,
            ),
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  module,
                  style: GoogleFonts.inter(
                    color: bento.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: difficultyColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        difficulty,
                        style: GoogleFonts.inter(
                          color: difficultyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      '+$points XP',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF00E1AB),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ElevatedButton(
            onPressed: () {
              if (!isCompleted) {
                // Navigate to the code editor (it expects an exerciseId)
                // Passing a dummy ID '1' for the mockup
                context.go('/exercises/1');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCompleted ? bento.surfaceContainerHighest : bento.primary,
              foregroundColor: isCompleted ? bento.onSurfaceVariant : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isCompleted ? 'Revisar' : 'Resolver'),
          ),
        ],
      ),
    );
  }
}
