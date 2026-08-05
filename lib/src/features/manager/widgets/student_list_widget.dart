import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/user_model.dart';

class StudentListWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildMainContent()),
        const SizedBox(width: AppSpacing.lg),
        Expanded(flex: 1, child: _buildSidePanel()),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppSpacing.lg),
        _buildStudentGrid(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
          ),
          Row(
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
                      onPressed: () {},
                      icon: const Icon(Icons.grid_view, size: 18, color: Color(0xFFE3E0F6)),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.view_list, size: 18, color: Color(0xFF908FA0)),
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
          ),
        ],
      ),
    );
  }

  Widget _buildStudentGrid() {
    if (students.isEmpty) {
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

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: students.asMap().entries.map((entry) {
        final i = entry.key;
        final student = entry.value;
        final initials = student.name
            .split(' ')
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join();
        final color = colors[i % colors.length];

        return _buildStudentCard(
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
  }

  Widget _buildStudentCard({
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
      onTap: () => onTap(student),
      borderRadius: BorderRadius.circular(12),
      hoverColor: const Color(0xFF1E1E2E),
      child: Container(
      width: 280,
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
                  onPressed: () => onTap(student),
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

  Widget _buildSidePanel() {
    return Column(
      children: [
        _buildChatPanel(),
        const SizedBox(height: AppSpacing.lg),
        _buildEngagementWidget(),
      ],
    );
  }

  Widget _buildChatPanel() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF464555), width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.forum, color: Color(0xFFC1C1FF), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Comunicação Global',
                      style: GoogleFonts.hankenGrotesk(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFFE3E0F6)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Color(0xFF00E1AB), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text('14 online', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChatMessage('System', 'Lembrete: Entrega do projeto de Data Science amanhã às 23:59.', false, '10:42 AM'),
                  const SizedBox(height: 16),
                  _buildChatMessage('Você', 'Alguém precisa de ajuda com o setup do ambiente?', true, '10:45 AM'),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF464555), width: 0.5)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF292839),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF464555)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Color(0xFFE3E0F6), fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Digite uma mensagem...',
                        hintStyle: TextStyle(color: const Color(0xFF908FA0)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Color(0xFFC1C1FF), size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(String sender, String message, bool isMe, String time) {
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              sender,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                color: isMe ? const Color(0xFFC1C1FF) : const Color(0xFF00E1AB),
              ),
            ),
            const SizedBox(width: 8),
            Text(time, style: GoogleFonts.jetBrainsMono(fontSize: 9, color: const Color(0xFF908FA0))),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF5D5FEF) : const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF464555)),
          ),
          child: Text(
            message,
            style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFFE3E0F6)),
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementWidget() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF008261).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.rocket_launch, color: Color(0xFF00E1AB), size: 24),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Engajamento',
            style: GoogleFonts.hankenGrotesk(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFFE3E0F6)),
          ),
          const SizedBox(height: 8),
          Text(
            'Motive a turma com um desafio relâmpago.',
            style: GoogleFonts.hankenGrotesk(fontSize: 12, color: const Color(0xFFC7C4D7)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Configurar Desafio'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFE3E0F6),
                side: const BorderSide(color: Color(0xFF464555)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}