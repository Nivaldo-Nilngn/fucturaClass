import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/user_model.dart';

class StudentDetailWidget extends StatelessWidget {
  final AppUser student;
  final VoidCallback? onBack;

  const StudentDetailWidget({
    super.key,
    required this.student,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(student.name);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(),
          const SizedBox(height: AppSpacing.md),
          _buildHeader(initials),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildLeftContent()),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 1, child: _buildRightContent()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildLeftContent(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildRightContent(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Text(
              'Alunos',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 13,
                color: const Color(0xFFC1C1FF),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFFC1C1FF),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF908FA0)),
        const SizedBox(width: 8),
        Text(student.name, style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFE3E0F6))),
      ],
    );
  }

  Widget _buildHeader(String initials) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    student.name,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE3E0F6),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008261).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'ATIVO',
                      style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFF00E1AB)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Turma: ${student.classId ?? 'Sábado'} · ${student.academyId ?? 'Lógica de Programação'}',
                style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFC7C4D7)),
              ),
            ],
          ),
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar Perfil'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE3E0F6),
                side: const BorderSide(color: Color(0xFF464555)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Enviar Material Didático'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D5FEF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeftContent() {
    return Column(
      children: [
        _buildCurrentCourseCard(),
        const SizedBox(height: AppSpacing.lg),
        _buildGradesCard(),
        const SizedBox(height: AppSpacing.lg),
        _buildHistoryCard(),
      ],
    );
  }

  Widget _buildCurrentCourseCard() {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURSO ATUAL',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lógica de Programação',
                    style: GoogleFonts.hankenGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFFE3E0F6)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '60%',
                    style: GoogleFonts.hankenGrotesk(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF00E1AB)),
                  ),
                  Text(
                    'CONCLUÍDO',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: const Color(0xFF292839),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00E1AB)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesCard() {
    return Container(
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
              Row(
                children: [
                  const Icon(Icons.bar_chart, color: Color(0xFFFFDF9E), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Notas por Módulo',
                    style: GoogleFonts.hankenGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFFE3E0F6)),
                  ),
                ],
              ),
              Text(
                'Média Geral: 8.5',
                style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFC7C4D7)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildGradeItem('Mod 1: Intro', 9.5, const Color(0xFF5D5FEF)),
          _buildGradeItem('Mod 2: Variáveis', 8.8, const Color(0xFF5D5FEF)),
          _buildGradeItem('Mod 3: Condicionais', 7.2, const Color(0xFFFFDF9E)),
          _buildGradeItem('Mod 4: Loops', 8.5, const Color(0xFF00E1AB)),
        ],
      ),
    );
  }

  Widget _buildGradeItem(String label, double grade, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFFC7C4D7)),
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF292839),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: grade / 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 32,
            child: Text(
              grade.toStringAsFixed(1),
              style: GoogleFonts.hankenGrotesk(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFE3E0F6)),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Container(
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
              Row(
                children: [
                  const Icon(Icons.history, color: Color(0xFFC1C1FF), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Histórico de Aulas',
                    style: GoogleFonts.hankenGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFFE3E0F6)),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text('Ver tudo', style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFFC1C1FF))),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildHistoryItem(Icons.check_circle, 'Laços de Repetição (For/While)', 'Participação ativa nos exercícios práticos.', '12 Out, 14:00', true),
          _buildHistoryItem(Icons.check_circle, 'Estruturas Condicionais (If/Else)', 'Concluiu desafio extra de lógica.', '05 Out, 14:00', true),
          _buildHistoryItem(Icons.cancel, 'Variáveis e Tipos de Dados', 'Falta justificada. Reposição agendada.', 'FALTA - 28 Set', false),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(IconData icon, String title, String subtitle, String date, bool isPresent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPresent
                  ? const Color(0xFF008261).withOpacity(0.2)
                  : const Color(0xFF93000A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: isPresent ? const Color(0xFF00E1AB) : const Color(0xFFFFB4AB), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.hankenGrotesk(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFFE3E0F6)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFFC7C4D7)),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              color: isPresent ? const Color(0xFFC7C4D7) : const Color(0xFFFFB4AB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightContent() {
    return Column(
      children: [
        _buildStatsGrid(),
        const SizedBox(height: AppSpacing.lg),
        _buildAttendanceCard(),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatItem(Icons.star, '12,450', 'XP TOTAL', const Color(0xFFFFDF9E))),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _buildStatItem(Icons.account_balance_wallet, '840', 'FUCTURA COINS', const Color(0xFF00E1AB))),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildStreakItem(),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.hankenGrotesk(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFFE3E0F6)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7)),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Color(0xFFFF6B35), size: 24),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '6 Semanas',
                    style: GoogleFonts.hankenGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFFE3E0F6)),
                  ),
                  Text(
                    'OFENSIVA ATUAL',
                    style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7)),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'EM ALTA',
              style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFFF6B35)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return Container(
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
            children: [
              const Icon(Icons.calendar_today, color: Color(0xFFC7C4D7), size: 18),
              const SizedBox(width: 8),
              Text(
                'Presença (Últimas 12 aulas)',
                style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFE3E0F6)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(12, (index) {
                final isPresent = index < 10;
                final isPending = index == 10;
                final isFuture = index == 11;
                return _buildAttendanceBar(isPresent, isPending, isFuture);
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '91%',
                style: GoogleFonts.hankenGrotesk(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF00E1AB)),
              ),
              Text(
                'Taxa de Presença',
                style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFFC7C4D7)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceBar(bool isPresent, bool isPending, bool isFuture) {
    Color color;
    if (isFuture) {
      color = const Color(0xFF292839);
    } else if (isPending) {
      color = const Color(0xFF5D5FEF).withOpacity(0.5);
    } else if (isPresent) {
      color = const Color(0xFF00E1AB);
    } else {
      color = const Color(0xFFFFB4AB);
    }

    return Container(
      width: 16,
      height: isFuture ? 10 : 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length > 2 ? 2 : name.length).toUpperCase();
  }
}