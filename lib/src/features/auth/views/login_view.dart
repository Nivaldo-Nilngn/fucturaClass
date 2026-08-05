import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuctura_lms_app/l10n/app_localizations.dart';
import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';
import 'package:fuctura_lms_app/src/features/auth/models/auth_state.dart';
import 'package:fuctura_lms_app/src/core/theme/app_theme.dart';
import 'package:fuctura_lms_app/src/features/auth/view_model/auth_view_model.dart';
import 'package:fuctura_lms_app/src/features/auth/widgets/login_form_widget.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Listen for auth success to navigate or show success message
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.loginSuccessMessage),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/home');
      }
    });

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < AppSpacing.mobileBreakpoint;
          return Stack(
            children: [
              Row(
                children: [
              // Left Side: Brand Identity (Hidden on mobile)
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color(0xFF121221),
                    child: Stack(
                      children: [
                        // Abstract Grid Background
                        Positioned.fill(
                          child: CustomPaint(
                            painter: GridPainter(),
                          ),
                        ),
                        // Content
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxxl),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Logo
                                SvgPicture.asset(
                                  'assets/logoFucturaColor.svg',
                                  height: 64,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                Text(
                                  'Fuctura Student Portal',
                                  style: TextStyle(
                                    color: const Color(0xFFE3E0F6),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Acelere sua carreira na tecnologia com nossa plataforma imersiva de aprendizado.\nDesafios de código, trilhas especializadas e uma comunidade vibrante de desenvolvedores.',
                                  style: TextStyle(
                                    color: const Color(0xFFC7C4D7),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.xxxl),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildFeatureItem(context, Icons.code, l10n.loginFeatureChallenges, const Color(0xFF5D5FEF)),
                                    const SizedBox(width: AppSpacing.md),
                                    _buildFeatureItem(context, Icons.emoji_events, l10n.loginFeatureRewards, const Color(0xFF00E1AB)),
                                    const SizedBox(width: AppSpacing.md),
                                    _buildFeatureItem(context, Icons.groups, l10n.loginFeatureCommunity, const Color(0xFFFFDF9E)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Right Side: Login Form
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl, 
                        vertical: isMobile ? AppSpacing.md : AppSpacing.xxxl
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (isMobile) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  onPressed: () => context.go('/'),
                                  tooltip: 'Voltar ao Portal',
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Center(
                                child: SvgPicture.asset(
                                  'assets/logoFucturaColor.svg',
                                  height: 48,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                            ],
                            Text(
                              l10n.loginWelcomeTitle,
                              style: isMobile
                                  ? Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)
                                  : Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 32),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              l10n.loginWelcomeSubtitle,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xxl),
                            const LoginFormWidget(),
                            SizedBox(height: isMobile ? AppSpacing.md : AppSpacing.xxxl),
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                    l10n.loginNewHere,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    l10n.loginRequestAccess,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildFooterLink(context, l10n.loginTerms),
                                _buildFooterDot(context),
                                _buildFooterLink(context, l10n.loginPrivacy),
                                _buildFooterDot(context),
                                _buildFooterLink(context, l10n.loginSupport),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
                ],
              ),
              // Back Button
              if (!isMobile)
                Positioned(
                top: AppSpacing.xl,
                left: AppSpacing.xl,
                child: Tooltip(
                  message: 'Voltar ao Portal',
                  child: InkWell(
                    onTap: () => context.go('/'),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_rounded, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(
                            'Voltar',
                            style: GoogleFonts.hankenGrotesk(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: const Color(0xFF14142B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                color: const Color(0xFFC7C4D7),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
    );
  }

  Widget _buildFooterDot(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        '•',
        style: TextStyle(color: Theme.of(context).colorScheme.outlineVariant),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.gridLineColor
      ..strokeWidth = 1;

    const double spacing = AppTheme.gridSpacing;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
