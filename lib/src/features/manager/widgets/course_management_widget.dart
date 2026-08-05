import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../auth/models/app_user.dart';
import '../models/course_model.dart';

class CourseManagementWidget extends StatelessWidget {
  final List<Course> courses;
  final List<Turma> turmas;
  final List<AppUser> professors;
  final Function(Course) onTapCourse;
  final Function(Turma) onTapTurma;
  final Function(Course)? onDeleteCourse;
  final Function(Turma)? onDeleteTurma;
  final VoidCallback? onAddCourse;
  final Function(Course)? onAddTurma;

  const CourseManagementWidget({
    super.key,
    required this.courses,
    required this.turmas,
    required this.professors,
    required this.onTapCourse,
    required this.onTapTurma,
    this.onDeleteCourse,
    this.onDeleteTurma,
    this.onAddCourse,
    this.onAddTurma,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildMainContent()),
              const SizedBox(width: AppSpacing.lg),
              Expanded(flex: 1, child: _buildSidePanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gestão de Cursos e Turmas',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE3E0F6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cadastre cursos, crie turmas e vincule professores.',
              style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFC7C4D7)),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onAddCourse,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Novo Curso'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5D5FEF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCoursesList(),
          const SizedBox(height: AppSpacing.lg),
          _buildTurmasList(),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
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
              Text(
                'Cursos Disponíveis',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              Text(
                '${courses.length} cursos',
                style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFF908FA0)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (courses.isEmpty)
            Text(
              'Nenhum curso cadastrado.',
              style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFF908FA0)),
            )
          else
            ...courses.map((course) => _buildCourseCard(course)),
        ],
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    final turmasDoCurso = turmas.where((t) => t.cursoId == course.id).toList();
    final turmasAtivas = turmasDoCurso.where((t) => t.status == TurmaStatus.ativa).length;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF5D5FEF).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              course.name.substring(0, 1).toUpperCase(),
              style: GoogleFonts.hankenGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5D5FEF),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
                Text(
                  course.description,
                  style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF343344),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${turmasDoCurso.length} turmas',
              style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7)),
            ),
          ),
          if (turmasAtivas > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF00E1AB).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$turmasAtivas ativas',
                style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFF00E1AB)),
              ),
            ),
          ],
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF908FA0), size: 18),
            onSelected: (value) {
              if (value == 'add_turma' && onAddTurma != null) {
                onAddTurma!(course);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'add_turma',
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 16, color: Color(0xFF00E1AB)),
                    const SizedBox(width: 8),
                    Text('Nova Turma', style: GoogleFonts.hankenGrotesk(fontSize: 13)),
                  ],
                ),
              ),
              if (onDeleteCourse != null)
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 16, color: Colors.red[400]),
                      const SizedBox(width: 8),
                      Text('Excluir', style: GoogleFonts.hankenGrotesk(fontSize: 13, color: Colors.red[400])),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTurmasList() {
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
              Text(
                'Turmas Ativas',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              Text(
                '${turmas.length} turmas',
                style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFF908FA0)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (turmas.isEmpty)
            Text(
              'Nenhuma turma criada.',
              style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFF908FA0)),
            )
          else
            ...turmas.map((turma) => _buildTurmaCard(turma)),
        ],
      ),
    );
  }

  Widget _buildTurmaCard(Turma turma) {
    final curso = courses.where((c) => c.id == turma.cursoId).firstOrNull;
    final statusColor = _getStatusColor(turma.status);

    return InkWell(
      onTap: () => onTapTurma(turma),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF464555)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.school, color: statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          turma.nome,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFE3E0F6),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getStatusText(turma.status),
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (curso != null) ...[
                        Icon(Icons.book_outlined, size: 12, color: const Color(0xFF908FA0)),
                        const SizedBox(width: 4),
                        Text(
                          curso.name,
                          style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(Icons.people_outline, size: 12, color: const Color(0xFF908FA0)),
                      const SizedBox(width: 4),
                      Text(
                        '${turma.alunoIds.length} alunos',
                        style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.person_outline, size: 12, color: const Color(0xFF908FA0)),
                      const SizedBox(width: 4),
                      Text(
                        '${turma.professorIds.length} professores',
                        style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (onDeleteTurma != null)
              IconButton(
                onPressed: () => onDeleteTurma!(turma),
                icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 18),
              ),
            const Icon(Icons.chevron_right, color: Color(0xFF908FA0), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSidePanel() {
    return Column(
      children: [
        _buildProfessoresPanel(),
        const SizedBox(height: AppSpacing.lg),
        _buildStatsWidget(),
      ],
    );
  }

  Widget _buildProfessoresPanel() {
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
          Text(
            'Professores\nVinculados',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE3E0F6),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (professors.isEmpty)
            Text(
              'Nenhum professor cadastrado.',
              style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFF908FA0)),
            )
          else
            ...professors.take(5).map((p) => _buildProfessorItem(p)),
        ],
      ),
    );
  }

  Widget _buildProfessorItem(AppUser professor) {
    final colors = [
      const Color(0xFF00E1AB),
      const Color(0xFF5D5FEF),
      const Color(0xFFC1C1FF),
      const Color(0xFFFFDF9E),
    ];
    final color = colors[professor.name.hashCode % colors.length];
    final initials = professor.name
        .split(' ')
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF292839),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  professor.name,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
                Text(
                  professor.email,
                  style: GoogleFonts.hankenGrotesk(fontSize: 10, color: const Color(0xFFC7C4D7)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF00E1AB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Ativo',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF00E1AB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsWidget() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Column(
        children: [
          _buildStatItem(Icons.school, '${turmas.length}', 'Turmas', const Color(0xFF5D5FEF)),
          const SizedBox(height: 12),
          _buildStatItem(Icons.book_outlined, '${courses.length}', 'Cursos', const Color(0xFF00E1AB)),
          const SizedBox(height: 12),
          _buildStatItem(Icons.person_outline, '${professors.length}', 'Professores', const Color(0xFFC1C1FF)),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE3E0F6),
              ),
            ),
            Text(
              label,
              style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(TurmaStatus status) {
    switch (status) {
      case TurmaStatus.ativa:
        return const Color(0xFF00E1AB);
      case TurmaStatus.concluida:
        return const Color(0xFF5D5FEF);
      case TurmaStatus.cancelada:
        return const Color(0xFFFF6B6B);
      case TurmaStatus.planejada:
        return const Color(0xFFFFDF9E);
    }
  }

  String _getStatusText(TurmaStatus status) {
    switch (status) {
      case TurmaStatus.ativa:
        return 'Ativa';
      case TurmaStatus.concluida:
        return 'Concluída';
      case TurmaStatus.cancelada:
        return 'Cancelada';
      case TurmaStatus.planejada:
        return 'Planejada';
    }
  }
}