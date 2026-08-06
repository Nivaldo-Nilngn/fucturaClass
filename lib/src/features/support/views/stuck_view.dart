import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../home/view_model/home_view_model.dart';
import '../../home/widgets/mobile_header_widget.dart';
import '../../home/widgets/desktop_header_widget.dart';

class StuckView extends ConsumerWidget {
  const StuckView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bento = theme.bento;
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117), // Fundo principal
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Novo Cabeçalho do Usuário
          homeStateAsync.when(
            data: (state) => MediaQuery.of(context).size.width > 800
                ? DesktopHeaderWidget(state: state, title: 'Suporte e Ajuda')
                : MobileHeaderWidget(state: state, title: 'Suporte e Ajuda'),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Header específico da página (opcional, mantendo o título original menor)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          
          // Body section
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E2E), // Fundo escuro do corpo
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Em que você travou?',
                      style: GoogleFonts.inter(
                        color: Colors.white54,
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
                      title: 'Minha IDE deu erro', // Atualizado de Eclipse para IDE
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
        color: const Color(0xFF243447), // Card escuro em vez do container branco
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            iconText,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white, // Texto branco para contrastar com o card escuro
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
