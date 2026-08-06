import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/auth_view_model.dart';
import '../models/auth_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/user_model.dart';

class UnifiedAuthView extends ConsumerStatefulWidget {
  const UnifiedAuthView({super.key});

  @override
  ConsumerState<UnifiedAuthView> createState() => _UnifiedAuthViewState();
}

class _UnifiedAuthViewState extends ConsumerState<UnifiedAuthView> {
  bool _isLogin = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _selectedUniverse = 'fuctura';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = ref.read(authViewModelProvider.notifier);
    if (_isLogin) {
      viewModel.login(_cpfController.text, _passwordController.text);
    } else {
      viewModel.register(
        _nameController.text,
        _cpfController.text,
        _passwordController.text,
        academyId: _selectedUniverse,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Falha: ${next.errorMessage}'),
            backgroundColor: const Color(0xFFFF5C5C),
          ),
        );
      } else if (next.status == AuthStatus.success) {
        final isStaff = next.user?.role == UserRole.admin || next.user?.role == UserRole.secretary;
        if (isStaff) {
          context.go('/manager/dashboard');
        } else if (next.user?.academyId == 'biblia3d') {
          context.go('/kids-home');
        } else {
          context.go('/home');
        }
      }
    });

    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117), // Modo Dark
      body: Stack(
        children: [
          // Background Waves
          Positioned.fill(
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),
          
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 48.0), // Remove global horizontal padding
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500), // Limita a largura no modo Web
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  // Logo Branca centralizada
                  Center(
                    child: SvgPicture.asset(
                      'assets/logoFuctura.svg',
                      height: 55,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Título Login centralizado
                  Center(
                    child: Text(
                      _isLogin ? 'Login' : 'Cadastro',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // The Form Card
                  Padding(
                    padding: const EdgeInsets.only(right: 56), // 56 de padding garante que o botão (-32) fique 24px longe da borda
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerRight,
                      children: [
                        // O Container principal
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E2E), // Card Dark Glass
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                              topLeft: Radius.zero, // Colado na esquerda
                              bottomLeft: Radius.zero,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              )
                            ],
                          ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(32, 24, 48, 24),
                          child: Form(
                            key: _formKey,
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutBack,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!_isLogin) ...[
                                    _buildTextField(
                                      controller: _nameController,
                                      hint: 'Nome Completo',
                                      icon: Icons.person_outline,
                                    ),
                                    const Divider(height: 32, color: Colors.white12),
                                  ],
                                  _buildTextField(
                                    controller: _cpfController,
                                    hint: 'CPF',
                                    icon: Icons.badge_outlined,
                                  ),
                                  const Divider(height: 32, color: Colors.white12),
                                  _buildTextField(
                                    controller: _passwordController,
                                    hint: 'Senha',
                                    icon: Icons.lock_outline,
                                    isPassword: true,
                                    obscureText: _obscurePassword,
                                    onTogglePassword: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  if (!_isLogin) ...[
                                    const Divider(height: 32, color: Colors.white12),
                                    _buildUniverseSelector(),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Floating Submit Button
                      Positioned(
                        right: -32, // Metade do botão de 64px fica para fora!
                        child: GestureDetector(
                          onTap: authState.status == AuthStatus.loading ? null : _submit,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00E1AB), Color(0xFF0055FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0055FF).withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: authState.status == AuthStatus.loading
                                  ? const SizedBox(
                                      width: 24, height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                  const SizedBox(height: 32),
                  
                  if (authState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 32, right: 32),
                      child: Text(
                        authState.errorMessage!,
                        style: const TextStyle(color: Color(0xFFFF5C5C), fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Bottom Links
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => setState(() {
                            _isLogin = !_isLogin;
                            _formKey.currentState?.reset();
                          }),
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1E2E),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _isLogin ? 'Criar nova conta' : 'Já tenho conta',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF00E1AB), // Ciano
                            ),
                          ),
                        ),
                        if (_isLogin)
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Esqueci a senha',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white54,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white54,
                              ),
                            ),
                          ),
                      ],
                    ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 14),
        icon: Icon(icon, color: Colors.white54, size: 22),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: onTogglePassword,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                    size: 20,
                  ),
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24), // Evita que o ícone aumente a altura do input
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        filled: false,
        isDense: true,
      ),
      validator: (value) => value == null || value.isEmpty ? '*' : null,
    );
  }

  Widget _buildUniverseSelector() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedUniverse,
        isExpanded: true,
        dropdownColor: const Color(0xFF1E1E2E),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
        items: const [
          DropdownMenuItem(value: 'fuctura', child: Text('Academia Fuctura')),
          DropdownMenuItem(value: 'biblia3d', child: Text('Academia Bíblia 3D')),
        ],
        onChanged: (val) {
          if (val != null) setState(() => _selectedUniverse = val);
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintTop = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF9A05C), Color(0xFFE56A54)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width * 0.7, size.height * 0.4))
      ..style = PaintingStyle.fill;

    final pathTop = Path();
    pathTop.moveTo(0, 0);
    pathTop.lineTo(0, size.height * 0.25);
    pathTop.quadraticBezierTo(
      size.width * 0.25, size.height * 0.2,
      size.width * 0.55, 0,
    );
    pathTop.close();

    canvas.drawShadow(pathTop, Colors.black.withOpacity(0.3), 10, true);
    canvas.drawPath(pathTop, paintTop);

    final paintBottom = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00C6FF), Color(0xFF0055FF)],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      ).createShader(Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4))
      ..style = PaintingStyle.fill;

    final pathBottom = Path();
    pathBottom.moveTo(size.width, size.height);
    pathBottom.lineTo(size.width, size.height * 0.75);
    pathBottom.quadraticBezierTo(
      size.width * 0.75, size.height * 0.8,
      size.width * 0.35, size.height,
    );
    pathBottom.close();

    canvas.drawShadow(pathBottom, Colors.black.withOpacity(0.3), 10, true);
    canvas.drawPath(pathBottom, paintBottom);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
