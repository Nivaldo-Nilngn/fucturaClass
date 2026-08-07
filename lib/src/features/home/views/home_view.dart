import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../auth/view_model/auth_view_model.dart';
import 'package:go_router/go_router.dart';
import '../view_model/home_view_model.dart';
import '../models/home_state.dart';
import '../../../core/models/user_model.dart';

import '../widgets/student_notices_widget.dart';
import '../widgets/student_shortcuts_widget.dart';
import '../widgets/mobile_header_widget.dart';
import '../widgets/desktop_header_widget.dart';
import '../widgets/welcome_card_widget.dart';
import '../../profile/views/profile_completion_view.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final user = authState.user;
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= AppSpacing.desktopBreakpoint;
        
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
                    // MobileHeaderWidget removed by request to move user data to SideMenu

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
    final hasClass = true; // MOCK: user?.classId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 80), // Espaço maior para o botão de menu (MenuBtn) e ícones flutuantes
        if (!isProfileComplete) _buildProfileBanner(context),
        if (!isProfileComplete) const SizedBox(height: AppSpacing.lg),
        WelcomeCardWidget(state: state, showStats: hasClass),
        const SizedBox(height: AppSpacing.lg),
        if (!hasClass) ...[
          _buildNoClassBanner(),
          const SizedBox(height: AppSpacing.lg),
        ],
        StudentNoticesWidget(state: state),
        const SizedBox(height: AppSpacing.lg),
        const StudentShortcutsWidget(),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildDesktopLayout(HomeState state, AppUser? user, BuildContext context) {
    final isProfileComplete = user?.isProfileComplete ?? true;
    final hasClass = true; // MOCK: user?.classId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isProfileComplete) _buildProfileBanner(context),
        if (!isProfileComplete) const SizedBox(height: AppSpacing.lg),
        WelcomeCardWidget(state: state, showStats: hasClass),
        const SizedBox(height: AppSpacing.lg),
        if (!hasClass) ...[
          _buildNoClassBanner(),
          const SizedBox(height: AppSpacing.lg),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (7/12)
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StudentNoticesWidget(state: state),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            // Right Column (5/12)
            const Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StudentShortcutsWidget(),
                ],
              ),
            ),
          ],
        ),
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
      decoration: isMobile
          ? BoxDecoration(
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
            )
          : BoxDecoration(
              color: const Color(0xFF14142B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00E1AB).withOpacity(0.5), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
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
                              color: Colors.white,
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
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const ProfileCompletionView(),
                  ),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E1AB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.rocket_launch_outlined, color: Color(0xFF00E1AB), size: 28),
                ),
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
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const ProfileCompletionView(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E1AB),
                    foregroundColor: const Color(0xFF14142B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                  child: const Text('Completar Agora', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ],
            ),
    );
  }
}
