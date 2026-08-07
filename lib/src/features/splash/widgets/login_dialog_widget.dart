import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:google_fonts/google_fonts.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../../auth/models/auth_state.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/user_model.dart';

// ─── Colors ────────────────────────────────────────────────────────────────
const _bg = Color(0xFF0D0F1A);
const _card = Color(0xFF141728);
const _accent = Color(0xFF00C9FF);
const _accentGlow = Color(0xFF0080CC);
const _inputBg = Color(0xFF1C2035);
const _textDim = Color(0xFF8892A4);

// ─── Dialog launcher ───────────────────────────────────────────────────────
void showCustomRiveDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "login",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (dialogContext, __, ___) {
      return _LoginDialogPage(dialogContext: dialogContext);
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}

// ─── Thin wrapper (keeps dialogContext accessible for close) ───────────────
class _LoginDialogPage extends StatelessWidget {
  final BuildContext dialogContext;
  const _LoginDialogPage({required this.dialogContext});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ProviderScope(
          child: _RiveLoginDialog(
            onClose: () => Navigator.of(dialogContext).pop(),
          ),
        ),
      ),
    );
  }
}

// ─── Main Dialog Widget ────────────────────────────────────────────────────
class _RiveLoginDialog extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  const _RiveLoginDialog({required this.onClose});

  @override
  ConsumerState<_RiveLoginDialog> createState() => _RiveLoginDialogState();
}

class _RiveLoginDialogState extends ConsumerState<_RiveLoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _showConfetti = false;

  SMITrigger? _errorTrigger;
  SMITrigger? _successTrigger;
  SMITrigger? _resetTrigger;
  SMITrigger? _confettiTrigger;

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCheckInit(Artboard artboard) {
    final ctrl = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (ctrl != null) {
      artboard.addController(ctrl);
      _errorTrigger = ctrl.findInput<bool>('Error') as SMITrigger?;
      _successTrigger = ctrl.findInput<bool>('Check') as SMITrigger?;
      _resetTrigger = ctrl.findInput<bool>('Reset') as SMITrigger?;
    }
  }

  void _onConfettiInit(Artboard artboard) {
    final ctrl = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (ctrl != null) {
      artboard.addController(ctrl);
      _confettiTrigger = ctrl.findInput<bool>('Trigger explosion') as SMITrigger?;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (_isRegisterMode) {
      ref.read(authViewModelProvider.notifier).register(
        _nameController.text.trim(),
        _cpfController.text.trim(),
        _passwordController.text,
      );
    } else {
      ref.read(authViewModelProvider.notifier).login(
        _cpfController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _handleAuthError() {
    _errorTrigger?.fire();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _resetTrigger?.fire();
      }
    });
  }

  void _handleAuthSuccess(AppUser? user) {
    _successTrigger?.fire();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _showConfetti = true;
      });
      _confettiTrigger?.fire();
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        final isStaff = user?.role == UserRole.admin || user?.role == UserRole.secretary;
        if (isStaff) {
          context.go('/manager/dashboard');
        } else if (user?.academyId == 'biblia3d') {
          context.go('/kids-home');
        } else {
          context.go('/home');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (_, next) {
      if (!_isLoading) return;
      if (next.status == AuthStatus.error) _handleAuthError();
      if (next.status == AuthStatus.success) _handleAuthSuccess(next.user);
    });

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 60,
            offset: const Offset(0, 24),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Main content ──────────────────────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  SvgPicture.asset('assets/logoFucturaColor.svg', height: 44),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    _isRegisterMode ? 'Criar Conta' : 'Acesso Restrito',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isRegisterMode
                        ? 'Preencha os dados para criar sua conta.'
                        : 'Entre com CPF e senha para continuar.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: _textDim, fontSize: 13),
                  ),
                  const SizedBox(height: 24),

                  // ── Register-only: Name ─────────────────────────
                  if (_isRegisterMode) ...[
                    _label('Nome Completo'),
                    _input(
                      controller: _nameController,
                      hint: 'Seu nome completo',
                      icon: Icons.badge_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Informe seu nome' : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── CPF ─────────────────────────────────────────
                  _label('CPF'),
                  _input(
                    controller: _cpfController,
                    hint: '00000000000',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 11,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Informe seu CPF';
                      if (v.length < 11) return 'CPF inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // ── Password ─────────────────────────────────────
                  _label('Senha'),
                  _input(
                    controller: _passwordController,
                    hint: _isRegisterMode ? 'Crie uma senha forte' : 'Sua senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscure: _obscurePassword,
                    onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                    validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 12),

                  // ── Register-only: Confirm Password ──────────────
                  if (_isRegisterMode) ...[
                    _label('Confirmar Senha'),
                    _input(
                      controller: _confirmPasswordController,
                      hint: 'Repita a senha',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscure: _obscureConfirm,
                      onToggleObscure: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      validator: (v) => v != _passwordController.text ? 'Senhas não conferem' : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Forgot password ───────────────────────────────
                  if (!_isRegisterMode)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotDialog,
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          'Esqueci minha senha',
                          style: GoogleFonts.inter(color: _accent, fontSize: 12),
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // ── Submit button ─────────────────────────────────
                  GestureDetector(
                    onTap: _isLoading ? null : _submit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 54,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isLoading
                              ? [_accentGlow.withOpacity(0.4), _accent.withOpacity(0.4)]
                              : [_accentGlow, _accent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                        boxShadow: _isLoading
                            ? []
                            : [
                                BoxShadow(
                                  color: _accent.withOpacity(0.35),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            _isRegisterMode ? 'Criar Conta' : 'Entrar',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Toggle Login / Register ───────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isRegisterMode ? 'Já tem conta? ' : 'Não tem conta? ',
                        style: GoogleFonts.inter(color: _textDim, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _isRegisterMode = !_isRegisterMode;
                          _formKey.currentState?.reset();
                        }),
                        child: Text(
                          _isRegisterMode ? 'Fazer login' : 'Cadastrar',
                          style: GoogleFonts.inter(
                            color: _accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: _accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // space for close button
                ],
              ),
            ),
          ),

          // ── Loading overlay (check.riv) ────────────────────────────
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: SizedBox(
                    height: 120,
                    width: 120,
                    child: RiveAnimation.asset(
                      'assets/rive/check.riv',
                      onInit: _onCheckInit,
                    ),
                  ),
                ),
              ),
            ),

          // ── Confetti overlay ───────────────────────────────────────
          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: Transform.scale(
                  scale: 6,
                  child: RiveAnimation.asset(
                    'assets/rive/confetti.riv',
                    onInit: _onConfettiInit,
                  ),
                ),
              ),
            ),

          // ── Close button ───────────────────────────────────────────
          Positioned(
            bottom: -20,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _card,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),   // end Stack
    ),     // end Container
    );     // end ConstrainedBox
  }

  // ── Helper builders ──────────────────────────────────────────────────────

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: GoogleFonts.inter(color: _textDim, fontSize: 13)),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
    int? maxLength,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: formatters,
        maxLength: maxLength,
        obscureText: isPassword && obscure,
        style: const TextStyle(color: Colors.white),
        validator: validator,
        decoration: InputDecoration(
          counterText: '',
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          prefixIcon: Icon(icon, color: _textDim, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: _textDim,
                    size: 18,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
          filled: true,
          fillColor: _inputBg,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _accent, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
        ),
      ),
    );
  }

  void _showForgotDialog() {
    final cpfCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Recuperar Senha',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Digite seu CPF para receber as instruções de recuperação.',
              style: GoogleFonts.inter(color: _textDim, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: cpfCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '00000000000',
                hintStyle: const TextStyle(color: Colors.white30),
                prefixIcon: const Icon(Icons.person_outline, color: _textDim),
                filled: true,
                fillColor: _inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar', style: GoogleFonts.inter(color: _textDim)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Instruções enviadas! Verifique seu e-mail cadastrado.'),
                  backgroundColor: _accent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: _accent),
            child: Text('Enviar', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
