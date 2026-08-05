import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

class BentoPresenceWidget extends StatelessWidget {
  final HomeState state;

  const BentoPresenceWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Container(
      decoration: BoxDecoration(
        color: bento.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: bento.outline, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Presença',
                      style: GoogleFonts.hankenGrotesk(
                        color: bento.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  'ÚLTIMAS 12 AULAS',
                  style: GoogleFonts.jetBrainsMono(
                    color: bento.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: state.attendanceHistory.map((attendance) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _AttendanceBox(attendance: attendance, bento: bento),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: bento.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(color: bento.onSurface, fontSize: 14),
                        children: [
                          const TextSpan(text: 'Você marcou Presença na '),
                          TextSpan(
                            text: state.attendanceMessageHighlight,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' â€” '),
                          TextSpan(
                            text: state.attendanceMessageStatus,
                            style: TextStyle(color: bento.tertiary),
                          ),
                          const TextSpan(text: ' do professor.'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: bento.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
                    ),
                    child: Text(
                      'PENDENTE',
                      style: GoogleFonts.jetBrainsMono(
                        color: bento.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceBox extends StatelessWidget {
  final Attendance attendance;
  final BentoColors bento;

  const _AttendanceBox({required this.attendance, required this.bento});

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;
    Color textColor;

    switch (attendance.status) {
      case AttendanceStatus.present:
        borderColor = bento.secondary;
        bgColor = bento.secondaryContainer.withOpacity(0.2);
        textColor = bento.secondary;
        break;
      case AttendanceStatus.absent:
        borderColor = bento.error;
        bgColor = bento.errorContainer.withOpacity(0.5);
        textColor = bento.error;
        break;
      case AttendanceStatus.pending:
      case AttendanceStatus.current:
        borderColor = bento.tertiary;
        bgColor = bento.tertiaryContainer.withOpacity(0.1);
        textColor = bento.tertiary;
        break;
      case AttendanceStatus.future:
        borderColor = bento.outlineVariant;
        bgColor = bento.surfaceVariant.withOpacity(0.5);
        textColor = bento.onSurfaceVariant;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        attendance.label,
        style: GoogleFonts.jetBrainsMono(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
