import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/learning_model.dart';
import '../services/learning_service.dart';

class MyClassesView extends StatefulWidget {
  final String classId;

  const MyClassesView({super.key, required this.classId});

  @override
  State<MyClassesView> createState() => _MyClassesViewState();
}

class _MyClassesViewState extends State<MyClassesView> {
  final _service = LearningService();
  bool _isLoading = true;
  List<TaughtContent> _contents = [];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  Future<void> _loadContents() async {
    setState(() => _isLoading = true);
    try {
      _contents = await _service.getTaughtContentsByClass(widget.classId);
    } catch (e) {
      debugPrint("Erro ao carregar conteúdos: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8E2),
      appBar: AppBar(
        title: Text('Minhas Aulas', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w900, color: const Color(0xFF7C5800))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF7C5800)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contents.isEmpty
              ? Center(
                  child: Text(
                    'Nenhum conteúdo publicado ainda.',
                    style: GoogleFonts.nunitoSans(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    final content = _contents[index];
                    return _buildContentCard(content);
                  },
                ),
    );
  }

  Widget _buildContentCard(TaughtContent content) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDEA8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu_book, color: Color(0xFF7C5800), size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aula do dia ${content.date.day}/${content.date.month}',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        content.content,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (content.observations != null && content.observations!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        content.observations!,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (content.materialUrl != null && content.materialUrl!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: launchUrl(Uri.parse(content.materialUrl!));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Abrindo link: ${content.materialUrl}')),
                    );
                  },
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('Acessar Material Externo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
