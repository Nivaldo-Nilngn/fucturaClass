import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_spacing.dart';
import '../../manager/models/course_model.dart';
import '../../../core/models/learning_model.dart';
import '../services/learning_service.dart';

class TaughtContentFormView extends StatefulWidget {
  final Turma turma;

  const TaughtContentFormView({super.key, required this.turma});

  @override
  State<TaughtContentFormView> createState() => _TaughtContentFormViewState();
}

class _TaughtContentFormViewState extends State<TaughtContentFormView> {
  final _service = LearningService();
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _obsController = TextEditingController();
  final _linkController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final content = TaughtContent(
        id: const Uuid().v4(),
        classId: widget.turma.id,
        professorId: 'professor_id', // TODO: Pegar do AuthState
        date: DateTime.now(),
        content: _contentController.text.trim(),
        observations: _obsController.text.trim().isEmpty ? null : _obsController.text.trim(),
        materialUrl: _linkController.text.trim().isEmpty ? null : _linkController.text.trim(),
      );

      await _service.addTaughtContent(content);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conteúdo ministrado publicado com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Novo Conteúdo', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              margin: const EdgeInsets.all(AppSpacing.xl),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Publicar Conteúdo Ministrado',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Turma: ${widget.turma.nome}',
                        style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      TextFormField(
                        controller: _contentController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Conteúdo da Aula (Resumo do que foi ensinado)',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _linkController,
                        decoration: const InputDecoration(
                          labelText: 'Link do Material (Google Drive, YouTube, etc) - Opcional',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.link),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _obsController,
                        decoration: const InputDecoration(
                          labelText: 'Observações Extras (Opcional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'PUBLICAR CONTEÚDO',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
