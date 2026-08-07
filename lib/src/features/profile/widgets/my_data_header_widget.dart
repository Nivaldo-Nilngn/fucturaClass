import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../views/profile_completion_view.dart';

class MyDataHeaderWidget extends StatelessWidget {
  const MyDataHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name, Status, and Class Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Rafael Souza',
                    style: GoogleFonts.hankenGrotesk(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E1AB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00E1AB).withOpacity(0.3)),
                    ),
                    child: Text(
                      'ATIVO',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF00E1AB),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Turma: Sábado • Lógica de Programação',
                style: GoogleFonts.inter(
                  color: bento.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Buttons
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ProfileCompletionView(),
                );
              },
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Editar Perfil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Em desenvolvimento: Enviar Material')),
                );
              },
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Enviar Material Didático'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B7BFF), // Purple/blue matching mockup
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
