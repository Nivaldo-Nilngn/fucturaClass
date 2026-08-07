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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;
          if (isDesktop) {
            return _buildDesktopLayout(authState);
          }
          return _buildMobileLayout(authState);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(AuthState authState) {
    return Row(
      children: [
        // Left Panel (Branding)
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF9A05C), Color(0xFFE56A54)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DesktopWavePainter(),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/logoFuctura.svg',
                        height: 80,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Acelere sua carreira na tecnologia.',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right Panel (Form)
        Expanded(
          flex: 7,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 48),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isLogin ? 'Bem-vindo de volta!' : 'Crie sua conta',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin
                          ? 'Faça login para continuar sua jornada.'
                          : 'Junte-se a nós e comece a aprender.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Form(
                      key: _formKey,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOutBack,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (!_isLogin) ...[
                              _buildDesktopTextField(
                                controller: _nameController,
                                hint: 'Nome Completo',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 24),
                            ],
                            _buildDesktopTextField(
                              controller: _cpfController,
                              hint: 'CPF',
                              icon: Icons.badge_outlined,
                            ),
                            const SizedBox(height: 24),
                            _buildDesktopTextField(
                              controller: _passwordController,
                              hint: 'Senha',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            if (!_isLogin) ...[
                              const SizedBox(height: 24),
                              _buildDesktopUniverseSelector(),
                            ],
                            const SizedBox(height: 40),
                            _buildSubmitButton(authState, isMobile: false),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (authState.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          authState.errorMessage!,
                          style: const TextStyle(color: Color(0xFFFF5C5C), fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => setState(() {
                            _isLogin = !_isLogin;
                            _formKey.currentState?.reset();
                          }),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(AuthState authState) {
    return Stack(
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
            padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E), // Card Dark Glass
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutBack,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              const SizedBox(height: 32),
                              // Fixed Floating Submit Button (now securely inside the card)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildSubmitButton(authState, isMobile: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                  Row(
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTextField({
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
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.white38, fontSize: 15),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8, right: 12),
          child: Icon(icon, color: Colors.white54, size: 22),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white54, size: 20),
                onPressed: onTogglePassword,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF1E1E2E), // Dark input background
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
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
        suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
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

  Widget _buildDesktopUniverseSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedUniverse,
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E2E),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
          items: const [
            DropdownMenuItem(value: 'fuctura', child: Text('Academia Fuctura')),
            DropdownMenuItem(value: 'biblia3d', child: Text('Academia Bíblia 3D')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedUniverse = val);
          },
        ),
      ),
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

  Widget _buildSubmitButton(AuthState authState, {required bool isMobile}) {
    if (isMobile) {
      return GestureDetector(
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
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00E1AB), Color(0xFF0055FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0055FF).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: authState.status == AuthStatus.loading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 20),
          ),
          child: authState.status == AuthStatus.loading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  _isLogin ? 'Entrar' : 'Cadastrar',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                ),
        ),
      );
    }
  }
}

class _DesktopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintTop = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFF9A05C), Color(0xFFE56A54)],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.6))
      ..style = PaintingStyle.fill;

    final pathTop = Path();
    pathTop.moveTo(size.width, 0);
    pathTop.lineTo(size.width, size.height * 0.4);
    pathTop.quadraticBezierTo(
      size.width * 0.8, size.height * 0.35,
      0, size.height * 0.1,
    );
    pathTop.lineTo(0, 0);
    pathTop.close();

    canvas.drawPath(pathTop, paintTop);

    final paintBottom = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00C6FF), Color(0xFF0055FF)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, size.height * 0.4, size.width, size.height * 0.6))
      ..style = PaintingStyle.fill;

    final pathBottom = Path();
    pathBottom.moveTo(0, size.height);
    pathBottom.lineTo(0, size.height * 0.6);
    pathBottom.quadraticBezierTo(
      size.width * 0.2, size.height * 0.65,
      size.width, size.height * 0.9,
    );
    pathBottom.lineTo(size.width, size.height);
    pathBottom.close();

    canvas.drawPath(pathBottom, paintBottom);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
