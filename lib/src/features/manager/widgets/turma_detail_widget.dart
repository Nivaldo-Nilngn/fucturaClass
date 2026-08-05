import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/user_model.dart';
import '../models/course_model.dart';
import '../../learning/views/attendance_form_view.dart';
import '../../learning/views/taught_content_form_view.dart';
import '../../learning/views/challenge_form_view.dart';

class TurmaDetailWidget extends StatelessWidget {
  final Turma turma;
  final Course? curso;
  final List<AppUser> professores;
  final List<AppUser> alunos;
  final VoidCallback? onBack;
  final Function(AppUser)? onAddProfessor;
  final Function(AppUser)? onRemoveProfessor;
  final Function(AppUser)? onAddAluno;
  final Function(AppUser)? onRemoveAluno;

  const TurmaDetailWidget({
    super.key,
    required this.turma,
    this.curso,
    this.professores = const [],
    this.alunos = const [],
    this.onBack,
    this.onAddProfessor,
    this.onRemoveProfessor,
    this.onAddAluno,
    this.onRemoveAluno,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(),
          const SizedBox(height: AppSpacing.md),
          _buildHeader(context),
          const SizedBox(height: AppSpacing.lg),
          _buildTabs(context),
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
              'Cursos',
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
        Text(
          curso?.name ?? 'Curso',
          style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFC7C4D7)),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.chevron_right, size: 16, color: Color(0xFF908FA0)),
        const SizedBox(width: 8),
        Text(
          turma.nome,
          style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFE3E0F6)),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final statusColor = _getStatusColor(turma.status);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE3E0F6),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(turma.status),
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${turma.mesAno} · ${turma.alunoIds.length} alunos · ${turma.professorIds.length} professores',
                style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFC7C4D7)),
              ),
            ],
          ),
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AttendanceFormView(turma: turma, alunos: alunos),
                  ),
                );
              },
              icon: const Icon(Icons.fact_check_outlined, size: 16),
              label: const Text('Lançar Presença'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00E1AB),
                side: const BorderSide(color: Color(0xFF00E1AB)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TaughtContentFormView(turma: turma),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline, size: 16),
              label: const Text('Novo Conteúdo'),
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

  Widget _buildTabs(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF464555), width: 0.5)),
            ),
            child: TabBar(
              isScrollable: true,
              labelColor: const Color(0xFFC1C1FF),
              unselectedLabelColor: const Color(0xFF908FA0),
              labelStyle: GoogleFonts.hankenGrotesk(fontSize: 13, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.hankenGrotesk(fontSize: 13),
              indicatorColor: const Color(0xFFC1C1FF),
              tabs: const [
                Tab(text: 'Visão Geral'),
                Tab(text: 'Professores'),
                Tab(text: 'Alunos'),
                Tab(text: 'Materiais'),
                Tab(text: 'Desafios'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildOverviewTab(),
                _buildProfessoresTab(),
                _buildAlunosTab(),
                _buildMateriaisTab(),
                _buildDesafiosTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
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
                Text(
                  'Informações da Turma',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildInfoRow('Curso', curso?.name ?? 'Não definido'),
                _buildInfoRow('Período', turma.mesAno),
                _buildInfoRow('Início', turma.dataInicio != null ? '${turma.dataInicio!.day}/${turma.dataInicio!.month}/${turma.dataInicio!.year}' : 'Não definido'),
                _buildInfoRow('Fim', turma.dataFim != null ? '${turma.dataFim!.day}/${turma.dataFim!.month}/${turma.dataFim!.year}' : 'Não definido'),
                _buildInfoRow('Status', _getStatusText(turma.status)),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildQuickStat(Icons.person_outline, '${turma.professorIds.length}', 'Professores', const Color(0xFF5D5FEF)),
              const SizedBox(height: AppSpacing.sm),
              _buildQuickStat(Icons.people_outline, '${turma.alunoIds.length}', 'Alunos', const Color(0xFF00E1AB)),
              const SizedBox(height: AppSpacing.sm),
              _buildQuickStat(Icons.book_outlined, '0', 'Materiais', const Color(0xFFC1C1FF)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessoresTab() {
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
                'Professores Vinculados',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              if (onAddProfessor != null)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Adicionar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF00E1AB),
                    side: const BorderSide(color: Color(0xFF00E1AB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (professores.isEmpty)
            Text(
              'Nenhum professor vinculado a esta turma.',
              style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFF908FA0)),
            )
          else
            ...professores.map((p) => _buildProfessorItem(p)),
        ],
      ),
    );
  }

  Widget _buildAlunosTab() {
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
                'Alunos Matriculados',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              if (onAddAluno != null)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Adicionar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF00E1AB),
                    side: const BorderSide(color: Color(0xFF00E1AB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (alunos.isEmpty)
            Text(
              'Nenhum aluno matriculado nesta turma.',
              style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFF908FA0)),
            )
          else
            ...alunos.map((a) => _buildAlunoItem(a)),
        ],
      ),
    );
  }

  Widget _buildMateriaisTab() {
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
            'Materiais Didáticos',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFE3E0F6),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nenhum material adicionado.',
            style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFF908FA0)),
          ),
        ],
      ),
    );
  }

  Widget _buildDesafiosTab(BuildContext context) {
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
                'Desafios',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChallengeFormView(turma: turma),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Novo Desafio'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFDF9E),
                  side: const BorderSide(color: Color(0xFFFFDF9E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nenhum desafio criado.',
            style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFF908FA0)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFF908FA0)),
          ),
          Text(
            value,
            style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFE3E0F6)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
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
      padding: const EdgeInsets.all(12),
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
            decoration: const BoxDecoration(
              color: Color(0xFF292839),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  professor.name,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
                Text(
                  professor.cpf,
                  style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
                ),
              ],
            ),
          ),
          if (onRemoveProfessor != null)
            IconButton(
              onPressed: () => onRemoveProfessor!(professor),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red[400], size: 20),
            ),
        ],
      ),
    );
  }

  Widget _buildAlunoItem(AppUser aluno) {
    final colors = [
      const Color(0xFF00E1AB),
      const Color(0xFF5D5FEF),
      const Color(0xFFC1C1FF),
      const Color(0xFFFFDF9E),
    ];
    final color = colors[aluno.name.hashCode % colors.length];
    final initials = aluno.name
        .split(' ')
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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
            decoration: const BoxDecoration(
              color: Color(0xFF292839),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aluno.name,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
                Text(
                  aluno.cpf,
                  style: GoogleFonts.hankenGrotesk(fontSize: 11, color: const Color(0xFFC7C4D7)),
                ),
              ],
            ),
          ),
          if (onRemoveAluno != null)
            IconButton(
              onPressed: () => onRemoveAluno!(aluno),
              icon: Icon(Icons.remove_circle_outline, color: Colors.red[400], size: 20),
            ),
        ],
      ),
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