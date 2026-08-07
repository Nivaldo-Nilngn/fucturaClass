import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/admin_state.dart';
import '../models/course_model.dart';
import '../view_model/admin_view_model.dart';
// import '../widgets/stats_card.dart'; // Unused
import '../widgets/student_list_widget.dart';
import '../widgets/student_detail_widget.dart';
import '../widgets/professor_list_widget.dart';
import '../widgets/course_management_widget.dart';
import '../widgets/turma_detail_widget.dart';
import '../../../core/models/user_model.dart';
import 'users_list_view.dart';
import '../../gamification/views/auction_management_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../auth/view_model/auth_view_model.dart';

class ManagerView extends ConsumerStatefulWidget {
  const ManagerView({super.key});

  @override
  ConsumerState<ManagerView> createState() => _ManagerViewState();
}

class _ManagerViewState extends ConsumerState<ManagerView> {
  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminViewModelProvider);
    final adminNotifier = ref.read(adminViewModelProvider.notifier);
    final location = GoRouterState.of(context).uri.path;

    final authState = ref.watch(authViewModelProvider);
    AppUser? currentUser = authState.user;

    AdminTab currentTab = adminState.selectedTab;
    if (location.startsWith('/manager/students')) {
      currentTab = AdminTab.students;
    } else if (location.startsWith('/manager/professors')) {
      currentTab = AdminTab.professors;
    } else if (location.startsWith('/manager/courses')) {
      currentTab = AdminTab.courses;
    } else {
      currentTab = AdminTab.dashboard;
    }

    if (adminState.selectedTab != currentTab) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        adminNotifier.selectTab(currentTab);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: _buildContent(adminState, adminNotifier, currentUser),
      ),
    );
  }

  Widget _buildContent(AdminDashboardState state, AdminViewModel notifier, AppUser? currentUser) {
    return Column(
      children: [
        _buildHeader(context, currentUser),
        Expanded(child: _buildPageContent(state, notifier)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppUser? currentUser) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF121221),
        border: Border(bottom: BorderSide(color: Color(0xFF464555), width: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            // Logo Fuctura
            SvgPicture.asset(
              'assets/logoFucturaColor.svg',
              height: 24,
            ),
            const SizedBox(width: AppSpacing.lg),
            
            if (!isMobile)
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF464555)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: AppSpacing.md),
                      const Icon(Icons.search, color: Color(0xFF908FA0), size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Search courses, docs, community...',
                          style: GoogleFonts.hankenGrotesk(
                            color: const Color(0xFF908FA0),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Spacer(),
            if (!isMobile) const SizedBox(width: AppSpacing.lg),
            
            if (!isMobile) ...[
              IconButton(
                tooltip: 'Gerenciar Usuários',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const UsersListView()));
                },
                icon: const Icon(Icons.people_alt, color: Color(0xFF00E1AB), size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                tooltip: 'Regras de Negócio',
                onPressed: () => context.go('/manager/business-rules'),
                icon: const Icon(Icons.policy_outlined, color: Color(0xFFC7C4D7), size: 22),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                tooltip: 'Gerenciar Leilões',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AuctionManagementView(academyId: 'mock_academy')));
                },
                icon: const Icon(Icons.emoji_events_outlined, color: Color(0xFFC7C4D7), size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(width: 1, height: 32, color: const Color(0xFF464555)),
              const SizedBox(width: AppSpacing.md),
            ],

            IconButton(
              tooltip: 'Avisos do Sistema',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => Dialog(
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.topRight,
                    insetPadding: const EdgeInsets.only(top: 64, right: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: _buildAvisosCard(dialogContext),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_active, color: Color(0xFFFFDF9E), size: 22),
            ),
            if (!isMobile) const SizedBox(width: AppSpacing.sm),

            Row(
              children: [
                if (!isMobile)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currentUser?.name ?? 'Carregando...',
                        style: GoogleFonts.hankenGrotesk(color: const Color(0xFFE3E0F6), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        currentUser?.role.name.toUpperCase() ?? 'ADMINISTRADOR',
                        style: GoogleFonts.jetBrainsMono(color: const Color(0xFFC7C4D7), fontSize: 10),
                      ),
                    ],
                  ),
                if (!isMobile) const SizedBox(width: AppSpacing.md),
                PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  color: const Color(0xFF1E1E2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == 'logout') {
                      ref.read(authViewModelProvider.notifier).logout();
                      context.go('/auth');
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          const Icon(Icons.settings, color: Color(0xFFC7C4D7), size: 18),
                          const SizedBox(width: 8),
                          Text('Configurações', style: GoogleFonts.hankenGrotesk(color: const Color(0xFFE3E0F6))),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 8),
                          Text('Sair', style: GoogleFonts.hankenGrotesk(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: Color(0xFF5D5FEF), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(
                      currentUser != null ? _getInitials(currentUser.name) : '...',
                      style: GoogleFonts.hankenGrotesk(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(AdminDashboardState state, AdminViewModel notifier) {
    switch (state.selectedTab) {
      case AdminTab.dashboard:
        return _buildDashboard(state, notifier);
      case AdminTab.students:
        return _buildStudentsTab(state, notifier);
      case AdminTab.professors:
        return _buildProfessorsTab(state, notifier);
      case AdminTab.courses:
        return _buildCoursesTab(state, notifier);
    }
  }

  Widget _buildDashboard(AdminDashboardState state, AdminViewModel notifier) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visão Geral',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFE3E0F6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Acompanhe as métricas principais do portal.',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              color: const Color(0xFFC7C4D7),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildLeftContent(state, notifier)),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 1, child: _buildRightContent(state)),
                  ],
                );
              }
              return Column(
                children: [
                  _buildLeftContent(state, notifier),
                  const SizedBox(height: AppSpacing.lg),
                  _buildRightContent(state),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeftContent(AdminDashboardState state, AdminViewModel notifier) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          Column(
            children: [
              _buildStatCard('TOTAL ALUNOS', state.totalStudents.toString(), Icons.people_outlined, const Color(0xFF00E1AB), '+12%'),
              const SizedBox(height: AppSpacing.md),
              _buildStatCard('PROFESSORES', state.totalProfessors.toString(), Icons.school_outlined, const Color(0xFFFFDF9E), 'Ativos'),
              const SizedBox(height: AppSpacing.md),
              _buildStatCard('CURSOS', state.totalCourses.toString(), Icons.library_books_outlined, const Color(0xFF5D5FEF), '+2'),
            ],
          )
        else
          Row(
            children: [
              Expanded(child: _buildStatCard('TOTAL ALUNOS', state.totalStudents.toString(), Icons.people_outlined, const Color(0xFF00E1AB), '+12%')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildStatCard('PROFESSORES', state.totalProfessors.toString(), Icons.school_outlined, const Color(0xFFFFDF9E), 'Ativos')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildStatCard('CURSOS', state.totalCourses.toString(), Icons.library_books_outlined, const Color(0xFF5D5FEF), '+2')),
            ],
          ),
        const SizedBox(height: AppSpacing.lg),
        _buildCoursesTable(state, notifier),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, String badge) {
    return Container(
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
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: const Color(0xFFC7C4D7),
                  letterSpacing: 0.5,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  badge,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTable(AdminDashboardState state, AdminViewModel notifier) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cursos',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddCourseDialog(notifier),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Cadastrar Novo Curso'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D5FEF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width < 600)
            Column(
              children: state.courses.map((course) => Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF464555), width: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D5FEF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.code, color: Color(0xFF5D5FEF), size: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.name,
                            style: GoogleFonts.hankenGrotesk(color: const Color(0xFFE3E0F6), fontSize: 14, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${state.turmasByCurso(course.id).length} turmas • ${state.studentsByTurma('all').length} alunos',
                            style: GoogleFonts.hankenGrotesk(color: const Color(0xFFC7C4D7), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(true),
                  ],
                ),
              )).toList(),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 600),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(0.5),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFF464555), width: 0.5)),
                      ),
                      children: [
                        _buildTableHeader('NOME DO CURSO'),
                        _buildTableHeader('ALUNOS INSCRITOS'),
                        _buildTableHeader('STATUS'),
                        _buildTableHeader('AÇÃO'),
                      ],
                    ),
                    ...state.courses.map((course) => TableRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFF464555), width: 0.3)),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5D5FEF).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.code, color: Color(0xFF5D5FEF), size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  course.name,
                                  style: GoogleFonts.hankenGrotesk(
                                    color: const Color(0xFFE3E0F6),
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '${state.turmasByCurso(course.id).length} turmas',
                            style: GoogleFonts.hankenGrotesk(color: const Color(0xFFC7C4D7), fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: _buildStatusBadge(true),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert, color: Color(0xFFC7C4D7), size: 18),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          color: const Color(0xFFC7C4D7),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF008261).withOpacity(0.2)
            : const Color(0xFF343344),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF00E1AB) : const Color(0xFF908FA0),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Ativo' : 'Rascunho',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: isActive ? const Color(0xFF00E1AB) : const Color(0xFF908FA0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightContent(AdminDashboardState state) {
    return Column(
      children: [
        _buildRankingCard(state),
      ],
    );
  }

  Widget _buildRankingCard(AdminDashboardState state) {
    return Container(
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
                  const Icon(Icons.emoji_events, color: Color(0xFFFFDF9E), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Ranking\nAlunos',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE3E0F6),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF464555)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D5FEF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('Top 5', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.white)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Text('Geral', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7))),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRankingItem(1, 'BL', 'Beatriz Lima', '3190 pts', const Color(0xFFFFDF9E), true),
          _buildRankingItem(2, 'JA', 'João Pedro Alves', '3020 pts', const Color(0xFFC7C4D7), false),
          _buildRankingItem(3, 'MF', 'Maria Fernanda', '2847 pts', const Color(0xFFC7C4D7), false),
          _buildRankingItem(4, 'CR', 'Camila Rocha', '2611 pts', const Color(0xFFC7C4D7), false),
          _buildRankingItem(5, 'DF', 'Diego Farias', '2398 pts', const Color(0xFFC7C4D7), false),
        ],
      ),
    );
  }

  Widget _buildRankingItem(int rank, String initials, String name, String points, Color rankColor, bool isFirst) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isFirst ? const Color(0xFF1E1E2E) : null,
        borderRadius: BorderRadius.circular(8),
        border: isFirst ? Border.all(color: const Color(0xFF464555)) : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: rankColor,
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF292839),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: GoogleFonts.jetBrainsMono(fontSize: 11, color: const Color(0xFFC7C4D7)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFE3E0F6)),
            ),
          ),
          Text(
            points,
            style: GoogleFonts.jetBrainsMono(fontSize: 12, color: const Color(0xFF00E1AB)),
          ),
        ],
      ),
    );
  }

  Widget _buildAvisosCard(BuildContext dialogContext) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avisos do Sistema',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(dialogContext),
                icon: const Icon(Icons.close, color: Color(0xFFC7C4D7), size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildAvisoItem('Hoje, 10:00', 'Manutenção programada no servidor de banco de dados.', const Color(0xFFFFDF9E)),
          const SizedBox(height: AppSpacing.md),
          _buildAvisoItem('Ontem, 15:30', 'Novo módulo de "Desafios" ativado com sucesso.', const Color(0xFF00E1AB)),
        ],
      ),
    );
  }

  Widget _buildAvisoItem(String time, String message, Color color) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: GoogleFonts.jetBrainsMono(fontSize: 10, color: const Color(0xFFC7C4D7)),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: GoogleFonts.hankenGrotesk(fontSize: 13, color: const Color(0xFFE3E0F6)),
          ),
        ],
      ),
    );
  }


  Widget _buildStudentsTab(AdminDashboardState state, AdminViewModel notifier) {
    if (state.selectedStudentId != null) {
      final student = state.selectedStudent;
      if (student != null) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: StudentDetailWidget(
            student: student,
            onBack: () => notifier.selectStudent(null),
          ),
        );
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gerenciar Alunos',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddStudentDialog(notifier),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Novo Aluno'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          StudentListWidget(
            students: state.students,
            onTap: (student) => notifier.selectStudent(student.id),
            onDelete: (student) => _confirmDelete(
              context: context,
              title: 'Remover aluno?',
              message: 'Deseja remover ${student.name} do sistema?',
              onConfirm: () => notifier.removeStudent(student.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessorsTab(AdminDashboardState state, AdminViewModel notifier) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gerenciar Professores',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddProfessorDialog(notifier),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Novo Professor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0041C8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ProfessorListWidget(
              professors: state.professors,
              onDelete: (AppUser professor) => _confirmDelete(
                context: context,
                title: 'Remover professor?',
                message: 'Deseja remover ${professor.name} do sistema?',
                onConfirm: () => notifier.removeProfessor(professor.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab(AdminDashboardState state, AdminViewModel notifier) {
    if (state.selectedTurmaId != null) {
      final turma = state.selectedTurma;
      if (turma != null) {
        final curso = state.courses.where((c) => c.id == turma.cursoId).firstOrNull;
        final professores = state.professorsByTurma(turma.id);
        final alunos = state.studentsByTurma(turma.id);
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: TurmaDetailWidget(
            turma: turma,
            curso: curso,
            professores: professores,
            alunos: alunos,
            onBack: () => notifier.selectTurma(null),
            onRemoveProfessor: (prof) => notifier.removeProfessorFromTurma(turma.id, prof.id),
            onRemoveAluno: (aluno) => notifier.removeStudentFromTurma(turma.id, aluno.id),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: CourseManagementWidget(
        courses: state.courses,
        turmas: state.turmas,
        professors: state.professors,
        onTapCourse: (course) => notifier.selectCourse(course.id),
        onTapTurma: (turma) => notifier.selectTurma(turma.id),
        onDeleteCourse: (course) => _confirmDelete(
          context: context,
          title: 'Remover curso?',
          message: 'Deseja remover "${course.name}" do sistema?',
          onConfirm: () => notifier.removeCourse(course.id),
        ),
        onDeleteTurma: (turma) => _confirmDelete(
          context: context,
          title: 'Remover turma?',
          message: 'Deseja remover "${turma.nome}" do sistema?',
          onConfirm: () => notifier.removeTurma(turma.id),
        ),
        onAddCourse: () => _showAddCourseDialog(notifier),
        onAddTurma: (course) => _showAddTurmaDialog(notifier, course),
      ),
    );
  }

  void _showAddStudentDialog(AdminViewModel notifier) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final photoUrlController = TextEditingController();
    final turmaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF14142B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cadastrar Aluno',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildStyledTextField(
                controller: nameController,
                label: 'Nome',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStyledTextField(
                controller: emailController,
                label: 'E-mail',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStyledTextField(
                controller: passwordController,
                label: 'Senha (mín. 6 caracteres)',
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStyledTextField(
                controller: photoUrlController,
                label: 'URL da Foto (opcional)',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildStyledTextField(
                controller: turmaController,
                label: 'Turma (opcional)',
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFC1C1FF),
                    ),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.length >= 6) {
                        notifier.addStudent(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          turma: turmaController.text.isNotEmpty ? turmaController.text : null,
                          photoUrl: photoUrlController.text.isNotEmpty ? photoUrlController.text : null,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E1E2E),
                      foregroundColor: const Color(0xFFC1C1FF),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: GoogleFonts.jetBrainsMono(
        color: const Color(0xFFE3E0F6),
        fontSize: 13,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.jetBrainsMono(
          color: const Color(0xFFE3E0F6),
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        filled: true,
        fillColor: const Color(0xFF1E1E2E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF464555)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF464555)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF5D5FEF)),
        ),
      ),
    );
  }

  void _showAddProfessorDialog(AdminViewModel notifier) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final turmaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadastrar Professor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: turmaController,
              decoration: const InputDecoration(labelText: 'Turma (opcional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                notifier.addProfessor(
                  name: nameController.text,
                  email: emailController.text,
                  turma: turmaController.text.isNotEmpty ? turmaController.text : null,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Cadastrar'),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog(AdminViewModel notifier) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Curso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Curso'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                notifier.addCourse(
                  name: nameController.text,
                  description: descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Criar Curso'),
          ),
        ],
      ),
    );
  }

  void _showAddTurmaDialog(AdminViewModel notifier, Course course) {
    final nameController = TextEditingController();
    int selectedMonth = DateTime.now().month;
    int selectedYear = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Nova Turma - ${course.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da Turma'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      decoration: const InputDecoration(labelText: 'Mês'),
                      items: List.generate(12, (i) {
                        final meses = [
                          'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
                          'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
                        ];
                        return DropdownMenuItem(value: i + 1, child: Text(meses[i]));
                      }),
                      onChanged: (value) {
                        setDialogState(() => selectedMonth = value ?? selectedMonth);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      decoration: const InputDecoration(labelText: 'Ano'),
                      items: List.generate(5, (i) {
                        final year = DateTime.now().year + i - 1;
                        return DropdownMenuItem(value: year, child: Text('$year'));
                      }),
                      onChanged: (value) {
                        setDialogState(() => selectedYear = value ?? selectedYear);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final meses = [
                    '', 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
                    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
                  ];
                  notifier.addTurma(
                    cursoId: course.id,
                    nome: nameController.text.isNotEmpty
                        ? nameController.text
                        : '${course.name} - ${meses[selectedMonth]}/$selectedYear',
                    mes: selectedMonth,
                    ano: selectedYear,
                    dataInicio: DateTime(selectedYear, selectedMonth, 1),
                    dataFim: DateTime(selectedYear, selectedMonth + 1, 0),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Criar Turma'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remover', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }
}