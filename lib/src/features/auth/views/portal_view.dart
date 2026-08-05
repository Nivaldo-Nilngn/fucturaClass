import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:fuctura_lms_app/src/core/theme/app_spacing.dart';

class PortalView extends StatelessWidget {
  const PortalView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      body: Stack(
        children: [
          // Background Glow
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    Color(0xFF1A1C30),
                    Color(0xFF0C0D18),
                  ],
                ),
              ),
            ),
          ),
          
          // Cosmic Particles Background
          const Positioned.fill(
            child: CosmicParticles(),
          ),

          // Top Navbar (Glassmorphism)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 64.0, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    border: const Border(
                      bottom: BorderSide(color: Colors.white24, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Minimalist School Logo
                      SvgPicture.asset(
                        'assets/logoFucturaColor.svg',
                        height: isMobile ? 24 : 32,
                        fit: BoxFit.contain,
                      ),
                      
                      // Admin Access Button
                      _buildAdminButton(context, isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Canvas
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 100, bottom: 64.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width < 600 ? 10 : 40),
                    Text(
                      'Bem-vindo(a)!',
                      style: GoogleFonts.quicksand(
                        fontSize: MediaQuery.of(context).size.width < 600 ? 40 : 64,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -1.2,
                        shadows: [
                          const Shadow(color: Color(0xCCB6C4FF), blurRadius: 30),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Escolha seu universo de aprendizado',
                      style: GoogleFonts.quicksand(
                        fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFC3C5D9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.width < 600 ? 30 : 60),
                    
                    // Portals Grid
                    Wrap(
                      spacing: MediaQuery.of(context).size.width < 600 ? 24 : 48,
                      runSpacing: MediaQuery.of(context).size.width < 600 ? 24 : 48,
                      alignment: WrapAlignment.center,
                      children: [
                        PortalCard(
                          title: 'Fuctura LMS',
                          subtitle: 'Cursos de Tecnologia',
                          tag: 'MÓDULO TÉCNICO',
                          actionText: 'INICIAR',
                          actionIcon: Icons.arrow_forward,
                          imagePath: 'assets/logoPrincipal.jpeg',
                          route: '/fuctura-login',
                          primaryColor: const Color(0xFF0055FF),
                        ),
                        PortalCard(
                          title: 'Bíblia 3D',
                          subtitle: 'Aventuras Infantis',
                          tag: '3D IMMERSIVE',
                          actionText: 'EXPLORAR',
                          actionIcon: Icons.explore,
                          imagePath: 'assets/biblia3d.png',
                          route: '/kids-login',
                          primaryColor: const Color(0xFFFFAA00),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 64.0, vertical: AppSpacing.sm),
              child: Opacity(
                opacity: 0.4,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '© 2024 Fuctura Technology. All Rights Reserved.',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFC3C5D9),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFooterLink('Support'),
                        const SizedBox(width: 16),
                        _buildFooterLink('Privacy Policy'),
                        const SizedBox(width: 16),
                        _buildFooterLink('Terms of Service'),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0055FF), Color(0xFF00737D)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D0055FF),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/fuctura-login'),
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMobile) ...[
                  Text(
                    'ADMIN ACCESS',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE3E6FF),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Icon(
                  Icons.account_circle,
                  color: Color(0xFFE3E6FF),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFFC3C5D9),
        letterSpacing: 1.2,
      ),
    );
  }
}

// ==========================================
// PORTAL CARD WITH 3D HOVER AND GLOW EFFECTS
// ==========================================

class PortalCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String tag;
  final String actionText;
  final IconData actionIcon;
  final String imagePath;
  final String route;
  final Color primaryColor;

  const PortalCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.actionText,
    required this.actionIcon,
    required this.imagePath,
    required this.route,
    required this.primaryColor,
  });

  @override
  State<PortalCard> createState() => _PortalCardState();
}

class _PortalCardState extends State<PortalCard> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final cardWidth = isMobile ? 320.0 : 450.0;
    final cardHeight = isMobile ? 220.0 : 480.0;
    final padding = isMobile ? 16.0 : 32.0;
    final logoContainerWidth = isMobile ? 140.0 : 250.0;
    final logoContainerHeight = isMobile ? 80.0 : 180.0;
    final ringSize = isMobile ? 80.0 : 180.0;
    final titleSize = isMobile ? 20.0 : 32.0;
    final subtitleSize = isMobile ? 12.0 : 16.0;
    final tagSize = isMobile ? 10.0 : 12.0;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient Glow Behind Card
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _isHovering ? 0.6 : 0.0,
                child: Container(
                  width: cardWidth * 0.7,
                  height: cardHeight * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor,
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // 3D Card
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..translate(0.0, _isHovering ? -10.0 : 0.0, _isHovering ? 20.0 : 0.0)
                  ..scale(_isHovering ? 1.05 : 1.0),
                transformAlignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isHovering ? widget.primaryColor.withOpacity(0.5) : Colors.white24,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.primaryColor.withOpacity(_isHovering ? 0.4 : 0.1),
                            blurRadius: _isHovering ? 80 : 30,
                            offset: Offset(0, _isHovering ? 30 : 20),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Top Left Tag
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: widget.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: widget.primaryColor.withOpacity(0.3)),
                              ),
                              child: Text(
                                widget.tag,
                                style: GoogleFonts.quicksand(
                                  fontSize: tagSize,
                                  fontWeight: FontWeight.w700,
                                  color: widget.primaryColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),

                          // Content Center
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: isMobile ? 20 : 40),
                                // Image with Rotating Portal Ring behind it
                                SizedBox(
                                  width: logoContainerWidth,
                                  height: logoContainerHeight,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Rotating Ring
                                      AnimatedOpacity(
                                        duration: const Duration(milliseconds: 500),
                                        opacity: _isHovering ? 1.0 : 0.0,
                                        child: AnimatedBuilder(
                                          animation: _ringController,
                                          builder: (_, child) {
                                            // Biblia rotates reverse, Fuctura normal
                                            final angle = widget.primaryColor == const Color(0xFFFFAA00) 
                                                ? -_ringController.value * 2 * pi 
                                                : _ringController.value * 2 * pi;
                                            return Transform.rotate(
                                              angle: angle,
                                              child: Container(
                                                width: ringSize,
                                                height: ringSize,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: widget.primaryColor.withOpacity(0.3),
                                                    width: 2,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: widget.primaryColor.withOpacity(0.2),
                                                      blurRadius: 40,
                                                      spreadRadius: -10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      
                                      // Main Logo
                                      AnimatedScale(
                                        duration: const Duration(milliseconds: 500),
                                        curve: Curves.easeOutBack,
                                        scale: _isHovering ? 1.1 : 1.0,
                                        child: Image.asset(
                                          widget.imagePath,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) => Icon(
                                            Icons.image_not_supported,
                                            size: 64,
                                            color: Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: isMobile ? 12 : 24),
                                
                                // Titles
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: GoogleFonts.quicksand(
                                    fontSize: titleSize,
                                    fontWeight: FontWeight.w700,
                                    color: _isHovering ? widget.primaryColor : const Color(0xFFE3E6FF),
                                  ),
                                  child: Text(widget.title),
                                ),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: GoogleFonts.quicksand(
                                    fontSize: subtitleSize,
                                    fontWeight: FontWeight.w400,
                                    color: _isHovering ? Colors.white : const Color(0xFFC3C5D9),
                                  ),
                                  child: Text(widget.subtitle),
                                ),
                              ],
                            ),
                          ),

                          // Bottom Right Action
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: GoogleFonts.quicksand(
                                fontSize: tagSize,
                                fontWeight: FontWeight.w700,
                                color: _isHovering ? widget.primaryColor : widget.primaryColor.withOpacity(0.5),
                                letterSpacing: 1.5,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(widget.actionText),
                                  const SizedBox(width: 8),
                                  Icon(
                                    widget.actionIcon,
                                    size: 16,
                                    color: _isHovering ? widget.primaryColor : widget.primaryColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// COSMIC PARTICLES BACKGROUND
// ==========================================

class CosmicParticles extends StatefulWidget {
  const CosmicParticles({super.key});

  @override
  State<CosmicParticles> createState() => _CosmicParticlesState();
}

class _CosmicParticlesState extends State<CosmicParticles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int particleCount = 50;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    final random = Random();
    for (int i = 0; i < particleCount; i++) {
      _particles.add(Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.1 + random.nextDouble() * 0.3,
        size: 1.0 + random.nextDouble() * 3.0,
        hue: random.nextBool() ? 230.0 : 200.0, // Blue or Cyan
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: ParticlePainter(_particles, _controller.value),
        );
      },
    );
  }
}

class Particle {
  final double x; // 0 to 1
  final double y; // 0 to 1
  final double speed;
  final double size;
  final double hue;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.hue,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Calculate current Y based on progress and particle speed
      double currentY = particle.y - (progress * particle.speed);
      
      // Loop around
      if (currentY < 0) currentY += 1.0;
      if (currentY > 1) currentY -= 1.0;

      // Calculate opacity based on Y position (fade in and out)
      double opacity = 1.0;
      if (currentY > 0.8) {
        opacity = (1.0 - currentY) * 5; // Fade in at bottom
      } else if (currentY < 0.2) {
        opacity = currentY * 5; // Fade out at top
      }
      
      opacity = opacity.clamp(0.0, 1.0) * 0.6; // Max opacity 0.6

      final paint = Paint()
        ..color = HSLColor.fromAHSL(opacity, particle.hue, 1.0, 0.75).toColor()
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, currentY * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
