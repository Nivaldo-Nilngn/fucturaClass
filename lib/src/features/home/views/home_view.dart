import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../auth/view_model/auth_view_model.dart';
import 'package:go_router/go_router.dart';
import '../view_model/home_view_model.dart';
import '../models/home_state.dart';
import '../../../core/models/user_model.dart';

import '../widgets/bento_module_progress_widget.dart';
import '../widgets/bento_next_class_widget.dart';
import '../widgets/bento_ranking_widget.dart';
import '../widgets/bento_presence_widget.dart';
import '../widgets/bento_checklist_widget.dart';
import '../widgets/bento_auction_widget.dart';
import '../widgets/mobile_header_widget.dart';
import '../widgets/desktop_header_widget.dart';
import '../widgets/welcome_card_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppSpacing.mobileBreakpoint;
        
        if (isDesktop) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: homeStateAsync.when(
              data: (state) {
                return Column(
                  children: [
                    DesktopHeaderWidget(state: state),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1440),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: _buildDesktopLayout(state, user, context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: AppSpacing.md),
                    Text('Erro ao carregar dados:\n$error', textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => ref.read(homeViewModelProvider.notifier).refresh(),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: homeStateAsync.when(
              data: (state) {
                return Column(
                  children: [
                    MobileHeaderWidget(state: state),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: _buildMobileLayout(state, user, context),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: AppSpacing.md),
                    Text('Erro ao carregar dados:\n$error', textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => ref.read(homeViewModelProvider.notifier).refresh(),
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildMobileLayout(HomeState state, AppUser? user, BuildContext context) {
    final isProfileComplete = user?.isProfileComplete ?? true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isProfileComplete) _buildProfileBanner(context),
        if (!isProfileComplete) const SizedBox(height: AppSpacing.lg),
        if (user?.classId == null) ...[
          _buildNoClassBanner(),
        ] else ...[
          BentoNextClassWidget(state: state),
          const SizedBox(height: AppSpacing.lg),
          BentoRankingWidget(state: state),
          const SizedBox(height: AppSpacing.lg),
          BentoPresenceWidget(state: state),
          const SizedBox(height: AppSpacing.lg),
          BentoChecklistWidget(state: state),
          const SizedBox(height: AppSpacing.lg),
          BentoAuctionWidget(state: state),
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildDesktopLayout(HomeState state, AppUser? user, BuildContext context) {
    final isProfileComplete = user?.isProfileComplete ?? true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isProfileComplete) _buildProfileBanner(context),
        if (!isProfileComplete) const SizedBox(height: AppSpacing.lg),
        if (user?.classId == null) ...[
          _buildNoClassBanner(),
          const SizedBox(height: AppSpacing.lg),
          WelcomeCardWidget(state: state),
        ] else ...[
          WelcomeCardWidget(state: state),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (7/12)
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BentoModuleProgressWidget(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    BentoNextClassWidget(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    BentoPresenceWidget(state: state),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              // Right Column (5/12)
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BentoRankingWidget(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    BentoChecklistWidget(state: state),
                    const SizedBox(height: AppSpacing.lg),
                    BentoAuctionWidget(state: state),
                  ],
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildNoClassBanner() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF243447),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Icon(Icons.school_outlined, color: Colors.white54, size: 48),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Aguardando Matrícula',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Você ainda não foi alocado em uma turma pela secretaria. Em breve seus módulos, ranking e presença aparecerão aqui.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBanner(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < AppSpacing.mobileBreakpoint;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00E1AB), Color(0xFF0055FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E1AB).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars, color: Color(0xFFFFD700), size: 40),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Complete seu Perfil!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ganhe +100 Pontos de Experiência ao preencher seus dados.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => context.go('/profile-completion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0055FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Completar Agora', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            )
          : Row(
              children: [
                const Icon(Icons.stars, color: Color(0xFFFFD700), size: 40),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Complete seu Perfil!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ganhe +100 Pontos de Experiência ao preencher seus dados.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => context.go('/profile-completion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0055FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Completar Agora', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
}
