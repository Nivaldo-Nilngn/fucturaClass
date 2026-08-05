import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_state.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../../auth/models/app_user.dart';

class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    return _fetchHomeData();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchHomeData());
  }

  Future<HomeState> _fetchHomeData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final authState = ref.read(authViewModelProvider);
    final user = authState.user;

    if (user == null) {
      return HomeState.initial();
    }

    return _buildStateForUser(user);
  }

  HomeState _buildStateForUser(AppUser user) {
    switch (user.role) {
      case UserRole.admin:
        return _adminState(user);
      case UserRole.professor:
        return _professorState(user);
      case UserRole.aluno:
        return _alunoState(user);
    }
  }

  HomeState _adminState(AppUser user) {
    return HomeState(
      firstName: user.name.split(' ').first,
      fullName: user.name,
      initials: _getInitials(user.name),
      badge1: 'FUCTURA',
      badge2: 'ADMINISTRADOR',
      points: 0,
      streak: 0,
      rankPosition: 0,
      moduleName: 'Painel Admin',
      moduleSubtitle: 'Gestão completa do sistema',
      moduleProgressPercent: 100,
      nextClassTopic: 'Gerenciar Usuários',
      nextClassDescription: 'Cadastre, edite e remova alunos e professores do sistema.',
      nextClassCodeSnippet: '',
      nextClassDate: '',
      nextClassTime: '',
      nextClassLocation: '',
      ranking: [],
      attendanceHistory: [],
      attendanceMessage: '',
      attendanceMessageHighlight: '',
      attendanceMessageStatus: '',
      checklist: [],
      auctions: [],
    );
  }

  HomeState _professorState(AppUser user) {
    return HomeState(
      firstName: user.name.split(' ').first,
      fullName: user.name,
      initials: _getInitials(user.name),
      badge1: 'FUCTURA',
      badge2: user.turma ?? 'PROFESSOR',
      points: 0,
      streak: 0,
      rankPosition: 0,
      moduleName: user.modulo ?? 'Meus Cursos',
      moduleSubtitle: 'Gerenciar aulas e alunos',
      moduleProgressPercent: 0,
      nextClassTopic: 'Próxima Aula',
      nextClassDescription: 'Prepare sua aula para os alunos.',
      nextClassCodeSnippet: '',
      nextClassDate: '',
      nextClassTime: '',
      nextClassLocation: '',
      ranking: [],
      attendanceHistory: [],
      attendanceMessage: '',
      attendanceMessageHighlight: '',
      attendanceMessageStatus: '',
      checklist: [],
      auctions: [],
    );
  }

  HomeState _alunoState(AppUser user) {
    return HomeState(
      firstName: user.name.split(' ').first,
      fullName: user.name,
      initials: _getInitials(user.name),
      badge1: 'FUCTURA',
      badge2: user.turma ?? 'TURMA',
      points: 2847,
      streak: 6,
      rankPosition: 3,
      moduleName: user.modulo ?? 'Módulo 3',
      moduleSubtitle: 'Lógica de Programação',
      moduleProgressPercent: 60,
      nextClassTopic: 'Programação Orientada a Objetos',
      nextClassDescription: 'Aprofunde-se em classes, herança e polimorfismo.',
      nextClassCodeSnippet: 'class Animal:\n    def __init__(self, nome):\n        self.nome = nome',
      nextClassDate: 'SÁBADO',
      nextClassTime: '14:00',
      nextClassLocation: '',
      ranking: [
        RankingUser(rank: 1, initials: 'BL', name: 'Beatriz Lima', points: 3190),
        RankingUser(rank: 2, initials: 'JP', name: 'João Pedro Alves', points: 3020),
        RankingUser(rank: 3, initials: _getInitials(user.name), name: user.name, points: 2847, isCurrentUser: true),
        RankingUser(rank: 4, initials: 'CR', name: 'Camila Rocha', points: 2611),
        RankingUser(rank: 5, initials: 'DF', name: 'Diego Farias', points: 2398),
      ],
      attendanceHistory: [
        Attendance(label: 'S1', status: AttendanceStatus.present),
        Attendance(label: 'S2', status: AttendanceStatus.present),
        Attendance(label: 'S3', status: AttendanceStatus.absent),
        Attendance(label: 'S4', status: AttendanceStatus.present),
        Attendance(label: 'S5', status: AttendanceStatus.present),
        Attendance(label: 'S6', status: AttendanceStatus.present),
        Attendance(label: 'S7', status: AttendanceStatus.present),
        Attendance(label: 'S8', status: AttendanceStatus.present),
        Attendance(label: 'S9', status: AttendanceStatus.present),
        Attendance(label: 'S10', status: AttendanceStatus.present),
        Attendance(label: 'S11', status: AttendanceStatus.pending),
        Attendance(label: 'S12', status: AttendanceStatus.future),
      ],
      attendanceMessage: 'Você marcou presença na Aula S11 — aguardando confirmação do professor.',
      attendanceMessageHighlight: 'Aula S11',
      attendanceMessageStatus: 'aguardando confirmação',
      checklist: [
        ChecklistItem(title: 'Variáveis e tipos de dados', isCompleted: true),
        ChecklistItem(title: 'Estruturas condicionais', isCompleted: true),
        ChecklistItem(title: 'Laços de repetição', isCompleted: true),
        ChecklistItem(title: 'Funções e escopo', isCompleted: false),
        ChecklistItem(title: 'Listas e dicionários', isCompleted: false),
      ],
      auctions: [
        AuctionItem(
          title: 'Camisa Fuctura Dev',
          minBid: 200,
          increment: 20,
          timeLeft: '2d 04h',
          currentBid: 480,
          topBidder: 'maior lance: Camila R.',
          isWinning: false,
        ),
        AuctionItem(
          title: 'Caneca Terminal',
          minBid: 80,
          increment: 10,
          timeLeft: '5h 12m',
          currentBid: 210,
          topBidder: 'seu lance é o maior',
          isWinning: true,
        ),
      ],
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

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  () => HomeViewModel(),
);