import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/user_model.dart';

class StudentListWidget extends StatefulWidget {
  final List<AppUser> students;
  final Function(AppUser) onTap;
  final Function(AppUser)? onDelete;

  const StudentListWidget({
    super.key,
    required this.students,
    required this.onTap,
    this.onDelete,
  });

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  String _searchQuery = '';
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return _buildMainContent(isMobile);
  }

  Widget _buildMainContent(bool isMobile) {
    final filteredStudents = widget.students.where((student) {
      final query = _searchQuery.toLowerCase();
      return student.name.toLowerCase().contains(query) ||
          (student.classId?.toLowerCase().contains(query) ?? false);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(isMobile),
        const SizedBox(height: AppSpacing.lg),
        _buildStudentContent(isMobile, filteredStudents),
      ],
    );
  }

  Widget _buildHeader(bool isMobile) {
    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diretório de Alunos',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE3E0F6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Gerencie e monitore o progresso dos alunos ativos.',
          style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFFC7C4D7)),
        ),
      ],
    );

    final searchWidget = Container(
      width: isMobile ? double.infinity : 220,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(color: Color(0xFFE3E0F6), fontSize: 13),
        decoration: const InputDecoration(
          hintText: 'Buscar aluno...',
          hintStyle: TextStyle(color: Color(0xFF908FA0)),
          prefixIcon: Icon(Icons.search, color: Color(0xFF908FA0), size: 18),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );

    final viewAndFilterWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF464555)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _isGridView = true),
                icon: Icon(Icons.grid_view, size: 18, color: _isGridView ? const Color(0xFFE3E0F6) : const Color(0xFF908FA0)),
              ),
              IconButton(
                onPressed: () => setState(() => _isGridView = false),
                icon: Icon(Icons.view_list, size: 18, color: !_isGridView ? const Color(0xFFE3E0F6) : const Color(0xFF908FA0)),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, size: 16),
          label: const Text('Filtrar'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFE3E0F6),
            side: const BorderSide(color: Color(0xFF464555)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );

    final actionsWidget = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              searchWidget,
              const SizedBox(height: AppSpacing.md),
              viewAndFilterWidget,
            ],
          )
        : Row(
            children: [
              searchWidget,
              const SizedBox(width: AppSpacing.md),
              viewAndFilterWidget,
            ],
          );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleWidget,
                const SizedBox(height: AppSpacing.md),
                actionsWidget,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleWidget,
                actionsWidget,
              ],
            ),
    );
  }

  Widget _buildStudentContent(bool isMobile, List<AppUser> filteredStudents) {
    if (filteredStudents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: const Color(0xFF14142B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF464555)),
        ),
        child: Center(
          child: Text(
            'Nenhum aluno encontrado.',
            style: GoogleFonts.hankenGrotesk(fontSize: 14, color: const Color(0xFF908FA0)),
          ),
        ),
      );
    }

    final colors = [
      const Color(0xFF00E1AB),
      const Color(0xFF5D5FEF),
      const Color(0xFFC1C1FF),
      const Color(0xFFFFDF9E),
      const Color(0xFFFF6B35),
    ];

    if (_isGridView) {
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: filteredStudents.asMap().entries.map((entry) {
          final i = entry.key;
          final student = entry.value;
          final initials = student.name
              .split(' ')
              .take(2)
              .map((w) => w[0].toUpperCase())
              .join();
          final color = colors[i % colors.length];

          return _buildStudentCard(
            isMobile: isMobile,
            student: student,
            name: student.name,
            turma: student.classId ?? 'Sem turma',
            course: 'Flutter',
            level: 12,
            progress: 0.75,
            streak: 7,
            xp: '2.5k',
            initials: initials,
            color: color,
          );
        }).toList(),
      );
    } else {
      return Column(
        children: filteredStudents.asMap().entries.map((entry) {
          final i = entry.key;
          final student = entry.value;
          final initials = student.name
              .split(' ')
              .take(2)
              .map((w) => w[0].toUpperCase())
              .join();
          final color = colors[i % colors.length];

          return _buildStudentListItem(
            student: student,
            name: student.name,
            turma: student.classId ?? 'Sem turma',
            course: 'Flutter',
            initials: initials,
            color: color,
          );
        }).toList(),
      );
    }
  }

  Widget _buildStudentCard({
    required bool isMobile,
    required AppUser student,
    required String name,
    required String turma,
    required String course,
    required int level,
    required double progress,
    required int streak,
    required String xp,
    required String initials,
    required Color color,
  }) {
    return InkWell(
      onTap: () => widget.onTap(student),
      borderRadius: BorderRadius.circular(12),
      hoverColor: const Color(0xFF1E1E2E),
      child: Container(
      width: isMobile ? double.infinity : 280,
      padding: const EdgeInsets.all(AppSpacing.md),
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
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF292839),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          initials,
                          style: GoogleFonts.hankenGrotesk(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF14142B), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFE3E0F6),
                        ),
                      ),
                      Text(
                        '$turma • $course',
                        style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF343344),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Lvl $level',
                  style: GoogleFonts.jetBrainsMono(fontSize: 10, color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso do Módulo',
                style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFE3E0F6)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFF292839),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF464555), width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildStatChip(Icons.local_fire_department, '$streak', const Color(0xFFFF6B35)),
                    const SizedBox(width: 8),
                    _buildStatChip(Icons.star, '$xp XP', const Color(0xFFFFDF9E)),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => widget.onTap(student),
                  icon: const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFC1C1FF)),
                  label: Text(
                    'Detalhes',
                    style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFFC1C1FF)),
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

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7)),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListItem({
    required AppUser student,
    required String name,
    required String turma,
    required String course,
    required String initials,
    required Color color,
  }) {
    return InkWell(
      onTap: () => widget.onTap(student),
      borderRadius: BorderRadius.circular(8),
      hoverColor: const Color(0xFF1E1E2E),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF14142B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF464555)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF292839),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: GoogleFonts.hankenGrotesk(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE3E0F6),
                    ),
                  ),
                  Text(
                    '$turma • $course',
                    style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFFC7C4D7)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF908FA0)),
          ],
        ),
      ),
    );
  }
}