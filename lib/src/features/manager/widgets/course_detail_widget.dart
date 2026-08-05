import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/course_model.dart';

class CourseDetailWidget extends StatelessWidget {
  final Course course;
  final VoidCallback? onBack;

  const CourseDetailWidget({
    super.key,
    required this.course,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (onBack != null)
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios),
              ),
            Text(
              course.name,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE3E0F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          course.description,
          style: GoogleFonts.hankenGrotesk(fontSize: 14, color: const Color(0xFFC7C4D7)),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: const Color(0xFF14142B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF464555)),
          ),
          child: Text(
            'Gerencie as turmas deste curso na tela anterior.',
            style: GoogleFonts.hankenGrotesk(fontSize: 14, color: const Color(0xFF908FA0)),
          ),
        ),
      ],
    );
  }
}