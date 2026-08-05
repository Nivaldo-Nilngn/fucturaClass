import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../view_model/home_view_model.dart';
import '../models/home_state.dart';

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
                                child: _buildDesktopLayout(state),
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
                          child: _buildMobileLayout(state),
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

  Widget _buildMobileLayout(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BentoNextClassWidget(state: state),
        const SizedBox(height: AppSpacing.lg),
        BentoRankingWidget(state: state),
        const SizedBox(height: AppSpacing.lg),
        BentoPresenceWidget(state: state),
        const SizedBox(height: AppSpacing.lg),
        BentoChecklistWidget(state: state),
        const SizedBox(height: AppSpacing.lg),
        BentoAuctionWidget(state: state),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildDesktopLayout(HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
