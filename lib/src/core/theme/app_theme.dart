import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoColors {
  final Color primary = const Color(0xFFC1C1FF);
  final Color onPrimary = const Color(0xFF1200A9);
  final Color primaryContainer = const Color(0xFF5D5FEF);
  final Color onPrimaryContainer = const Color(0xFFFAF7FF);
  
  final Color secondary = const Color(0xFFFFDF9E);
  final Color onSecondary = const Color(0xFF3F2E00);
  final Color secondaryContainer = const Color(0xFFFABD00);
  final Color onSecondaryContainer = const Color(0xFF6A4E00);
  
  final Color tertiary = const Color(0xFF00E1AB);
  final Color onTertiary = const Color(0xFF003828);
  final Color tertiaryContainer = const Color(0xFF008261);
  final Color onTertiaryContainer = const Color(0xFFE3FFF0);
  
  final Color error = const Color(0xFFFFB4AB);
  final Color onError = const Color(0xFF690005);
  final Color errorContainer = const Color(0xFF93000A);
  final Color onErrorContainer = const Color(0xFFFFDAD6);
  
  final Color surface = const Color(0xFF121221);
  final Color onSurface = const Color(0xFFE3E0F6);
  final Color surfaceVariant = const Color(0xFF343344);
  final Color onSurfaceVariant = const Color(0xFFC7C4D7);
  
  final Color surfaceContainerLowest = const Color(0xFF0D0D1C);
  final Color surfaceContainerLow = const Color(0xFF1A1A2A);
  final Color surfaceContainer = const Color(0xFF1E1E2E);
  final Color surfaceContainerHigh = const Color(0xFF292839);
  final Color surfaceContainerHighest = const Color(0xFF343344);
  
  final Color outline = const Color(0xFF908FA0);
  final Color outlineVariant = const Color(0xFF464555);
}

extension BentoThemeExtension on ThemeData {
  BentoColors get bento => BentoColors();
}

class AppTheme {
  static const Color primaryColor = Color(0xFFC1C1FF);
  static const Color backgroundColor = Color(0xFF121221);
  static const Color surfaceColor = const Color(0xFF14142B);
  static const Color onSurface = const Color(0xFFE3E0F6);
  static const Color onSurfaceVariant = const Color(0xFFC7C4D7);
  static const Color outline = const Color(0xFF908FA0);
  static const Color outlineVariant = const Color(0xFF464555);
  
  static const Color successColor = Color(0xFF00E1AB);
  static const Color warningColor = const Color(0xFFFFDF9E);
  
  // Specific UI colors
  static const Color githubButtonColor = Color(0xFF2F3133);
  static const Color githubButtonText = Colors.white;
  static const Color gridLineColor = Color(0xFF292839);
  static const double gridSpacing = 40.0;
  
  static const Color subtleShadowColor = Color(0x05000000);
  static const Color mediumShadowColor = Color(0x0C000000);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        surface: surfaceColor,
        background: backgroundColor, // ignore: deprecated_member_use
        onPrimary: Color(0xFF1200A9),
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.hankenGrotesk(
          color: primaryColor,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.hankenGrotesk(
          color: onSurface,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.hankenGrotesk(
          color: onSurface,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.hankenGrotesk(
          color: onSurfaceVariant,
          fontSize: 14,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          color: onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1A2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.jetBrainsMono(color: onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w700),
        hintStyle: GoogleFonts.hankenGrotesk(color: outline),
      ),
    );
  }

  static BoxDecoration featureBoxDecoration(Color topBorderColor) {
    return BoxDecoration(
      color: const Color(0xFF14142B),
      borderRadius: BorderRadius.circular(8),
      border: Border(
        top: BorderSide(color: topBorderColor, width: 2),
        left: BorderSide(color: outlineVariant.withOpacity(0.3)),
        right: BorderSide(color: outlineVariant.withOpacity(0.3)),
        bottom: BorderSide(color: outlineVariant.withOpacity(0.3)),
      ),
    );
  }
  
  static BoxDecoration logoBoxDecoration(Color borderColor) {
    return BoxDecoration(
      color: const Color(0xFF14142B),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: borderColor),
    );
  }
}