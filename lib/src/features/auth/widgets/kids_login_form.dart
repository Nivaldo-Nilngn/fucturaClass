import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';
import 'package:fuctura_lms_app/src/features/auth/view_model/auth_view_model.dart';
import 'package:fuctura_lms_app/src/features/auth/models/auth_state.dart';

class KidsLoginForm extends ConsumerStatefulWidget {
  const KidsLoginForm({super.key});

  @override
  ConsumerState<KidsLoginForm> createState() => _KidsLoginFormState();
}

class _KidsLoginFormState extends ConsumerState<KidsLoginForm> {
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _quickLogin(String cpf, String password) {
    _cpfController.text = cpf;
    _passwordController.text = password;
    ref.read(authViewModelProvider.notifier).login(cpf, password);
  }

  void _submit() {
    ref.read(authViewModelProvider.notifier).login(
          _cpfController.text,
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFFE53935);
    const buttonColor = Color(0xFFFFB300);
    final authState = ref.watch(authViewModelProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Pronto para a sua próxima aventura?',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Quick Access Card
          Text(
            'Acesso rápido',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: () => _quickLogin('11111111111', '123456'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2ECC71).withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.school, color: Color(0xFF2ECC71), size: 32),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Aluno Aventureiro',
                    style: GoogleFonts.hankenGrotesk(
                      color: const Color(0xFF2ECC71),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[300])),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'ou digite seus dados',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[300])),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // CPF Input
          Text(
            'Qual é o seu CPF?',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _cpfController,
            style: const TextStyle(color: Colors.black87),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Digite seu CPF',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.badge_outlined, color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: themeColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          // Password Input
          Text(
            'Sua senha secreta',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: _passwordController,
            obscureText: true,
            obscuringCharacter: '✱',
            style: const TextStyle(color: Colors.black87, letterSpacing: 8, fontSize: 18),
            decoration: InputDecoration(
              hintText: '******',
              hintStyle: TextStyle(color: Colors.grey[400], letterSpacing: 8),
              counterText: '',
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: themeColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          if (authState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(
                authState.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          
          // Action Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: authState.status == AuthStatus.loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.brown[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: buttonColor.withOpacity(0.5),
              ),
              child: authState.status == AuthStatus.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Entrar na Aventura!',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.rocket_launch, size: 20),
                      ],
                    ),
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: TextButton(
              onPressed: () {
                // Forgot password action
              },
              child: Text(
                'Esqueci minha senha secreta',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
