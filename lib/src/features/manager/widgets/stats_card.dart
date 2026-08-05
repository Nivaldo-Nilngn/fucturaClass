import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: const Color(0xFF14142B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF464555)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                Icon(Icons.arrow_forward_ios, color: const Color(0xFF908FA0), size: 14),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE3E0F6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                color: const Color(0xFFC7C4D7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}