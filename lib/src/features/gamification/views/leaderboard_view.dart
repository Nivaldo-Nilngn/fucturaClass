import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../services/gamification_service.dart';

class LeaderboardView extends StatefulWidget {
  final String classId;

  const LeaderboardView({super.key, required this.classId});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  final _service = GamificationService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _topStudents = [];

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  Future<void> _loadRanking() async {
    setState(() => _isLoading = true);
    try {
      _topStudents = await _service.getTopStudentsByClass(widget.classId);
    } catch (e) {
      debugPrint('Erro no ranking: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8E2), // Fundo bege claro do tema Kids
      appBar: AppBar(
        title: Text('Placar de Líderes', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w900, color: const Color(0xFF7C5800))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF7C5800)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _topStudents.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum aluno encontrado na turma.',
                    style: GoogleFonts.nunitoSans(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      itemCount: _topStudents.length,
                      itemBuilder: (context, index) {
                        final student = _topStudents[index];
                        return _buildRankingCard(student, index + 1);
                      },
                    ),
                  ),
                ),
    );
  }

  Widget _buildRankingCard(Map<String, dynamic> student, int position) {
    final isTop3 = position <= 3;
    final color = _getPositionColor(position);

    return Card(
      elevation: isTop3 ? 8 : 2,
      shadowColor: color.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isTop3 ? BorderSide(color: color, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Medalha ou Número
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isTop3 ? color.withOpacity(0.2) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isTop3
                    ? Icon(Icons.emoji_events, color: color, size: 28)
                    : Text(
                        '#$position',
                        style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey.shade600),
                      ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            
            // Nome
            Expanded(
              child: Text(
                student['name'] ?? 'Aluno Misterioso',
                style: GoogleFonts.nunitoSans(
                  fontSize: 18,
                  fontWeight: isTop3 ? FontWeight.w900 : FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            
            // Moedas
            Row(
              children: [
                Text(
                  '${student['fucturaCoins'] ?? 0}',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber.shade700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Ouro
      case 2:
        return const Color(0xFFC0C0C0); // Prata
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.transparent;
    }
  }
}
