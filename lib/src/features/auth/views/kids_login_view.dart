import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fuctura_lms_app/l10n/app_localizations.dart';
import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';
import 'package:fuctura_lms_app/src/features/auth/models/auth_state.dart';
import 'package:fuctura_lms_app/src/features/auth/view_model/auth_view_model.dart';
import 'package:fuctura_lms_app/src/features/auth/widgets/kids_login_form.dart';

class KidsLoginView extends ConsumerWidget {
  const KidsLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for auth success to navigate to home
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.success) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.loginSuccessMessage),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/kids-home');
      }
    });

    const leftBackgroundColor = Color(0xFF1E88E5); // Bíblia 3D Blue Theme

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < AppSpacing.mobileBreakpoint;
          
          return Stack(
            children: [
              // Main Split Layout
              Row(
                children: [
                  // Left Side: Brand Identity (Hidden on mobile)
                  if (!isMobile)
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: leftBackgroundColor,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 300,
                                alignment: Alignment.bottomCenter,
                                child: Icon(
                                  Icons.auto_awesome, 
                                  size: 200, 
                                  color: Colors.white.withOpacity(0.5)
                                ),
                              ),
                            ),
                            
                            // Logo Area
                            Positioned(
                              top: AppSpacing.xxxl,
                              left: AppSpacing.xxxl,
                              right: AppSpacing.xxxl,
                              child: Column(
                                children: [
                                  Text(
                                    'BÍBLIA 3D',
                                    style: GoogleFonts.pangolin(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Aventuras Épicas!',
                                    style: GoogleFonts.hankenGrotesk(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4F7FC),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.xxl, 
                            vertical: isMobile ? AppSpacing.md : AppSpacing.xxxl
                          ),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 450),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  const SizedBox(height: AppSpacing.sm),
                                  Center(
                                    child: Image.asset(
                                      'assets/biblia3d.png',
                                      height: 64,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xl),
                                ],
                                const KidsLoginForm(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Top Right Controls (Back Button)
              if (!isMobile)
                Positioned(
                top: AppSpacing.xl,
                left: AppSpacing.xl,
                child: Tooltip(
                  message: 'Voltar ao Início',
                  child: InkWell(
                    onTap: () => context.go('/'),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
}
