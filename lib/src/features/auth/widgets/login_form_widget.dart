import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fuctura_lms_app/src/shared/widgets/custom_text_field.dart';
import 'package:fuctura_lms_app/src/shared/widgets/primary_button.dart';
import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';
import 'package:fuctura_lms_app/src/features/auth/models/auth_state.dart';
import 'package:fuctura_lms_app/src/features/auth/view_model/auth_view_model.dart';

class LoginFormWidget extends ConsumerStatefulWidget {
  const LoginFormWidget({super.key});

  @override
  ConsumerState<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends ConsumerState<LoginFormWidget> {
  final _cpfController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _rememberMe = false;

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
    final authState = ref.watch(authViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Acesso rápido',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickAccessCard(
                title: 'Admin',
                subtitle: 'Acesso total',
                icon: Icons.admin_panel_settings,
                color: const Color(0xFFE74C3C),
                onTap: () => _quickLogin('00000000000', '123456'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickAccessCard(
                title: 'Aluno',
                subtitle: 'Painel e aulas',
                icon: Icons.school,
                color: const Color(0xFF2ECC71),
                onTap: () => _quickLogin('11111111111', '123456'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickAccessCard(
                title: 'Professor',
                subtitle: 'Gestão de turmas',
                icon: Icons.cast_for_education,
                color: const Color(0xFF3498DB),
                onTap: () => _quickLogin('22222222222', '123456'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickAccessCard(
                title: 'Secretaria',
                subtitle: 'Gestão acadêmica',
                icon: Icons.support_agent,
                color: const Color(0xFFF39C12),
                onTap: () => _quickLogin('33333333333', '123456'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'ou entre com seu CPF',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        CustomTextField(
          controller: _cpfController,
          label: 'CPF',
          hint: 'Digite seu CPF',
          prefixIcon: Icons.badge_outlined,
          keyboardType: TextInputType.number,
          onChanged: (val) => _cpfController.text = val,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Senha', style: Theme.of(context).textTheme.labelSmall),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Esqueceu a senha?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        CustomTextField(
          controller: _passwordController,
          label: '',
          hint: 'Digite sua senha',
          prefixIcon: Icons.lock_outline,
          obscureText: true,
          onChanged: (val) => _passwordController.text = val,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (val) => setState(() => _rememberMe = val ?? false),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Lembrar de mim',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
        PrimaryButton(
          text: 'Entrar',
          isLoading: authState.status == AuthStatus.loading,
          onPressed: _submit,
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: GoogleFonts.hankenGrotesk(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}