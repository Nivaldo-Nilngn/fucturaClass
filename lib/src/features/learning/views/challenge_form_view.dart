import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/learning_model.dart';
import '../../manager/models/course_model.dart';
import '../services/learning_service.dart';

class ChallengeFormView extends StatefulWidget {
  final Turma turma;

  const ChallengeFormView({super.key, required this.turma});

  @override
  State<ChallengeFormView> createState() => _ChallengeFormViewState();
}

class _ChallengeFormViewState extends State<ChallengeFormView> {
  final _service = LearningService();
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _pointsController = TextEditingController(text: '100');

  // Question fields
  final _questionTextController = TextEditingController();
  QuestionType _selectedType = QuestionType.multipleChoice;
  QuestionDifficulty _selectedDifficulty = QuestionDifficulty.medium;

  // For multiple choice
  final List<TextEditingController> _optionsControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int _correctOptionIndex = 0;

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    try {
      final questionId = const Uuid().v4();
      final challengeId = const Uuid().v4();
      final professorId = 'professor_id'; // TODO: pegar do AuthState

      // 1. Criar a Questão
      List<String>? options;
      String? correctAnswer;

      if (_selectedType == QuestionType.multipleChoice) {
        options = _optionsControllers.map((c) => c.text.trim()).toList();
        correctAnswer = options[_correctOptionIndex];
      }

      final question = Question(
        id: questionId,
        category: 'Desafio',
        type: _selectedType,
        difficulty: _selectedDifficulty,
        text: _questionTextController.text.trim(),
        correctAnswer: correctAnswer,
        options: options,
        professorId: professorId,
        createdAt: DateTime.now(),
      );

      // 2. Criar o Desafio vinculado à Questão
      final challenge = Challenge(
        id: challengeId,
        code: questionId, // Vamos usar 'code' para guardar o ID da questão por simplicidade
        professorId: professorId,
        classId: widget.turma.id,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        points: int.tryParse(_pointsController.text) ?? 100,
        startsAt: DateTime.now(),
        endsAt: DateTime.now().add(const Duration(days: 7)),
      );

      await _service.addQuestion(question);
      await _service.addChallenge(challenge);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Desafio criado com sucesso!')),
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
        title: Text('Novo Desafio/Exercício', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  _buildGeneralCard(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildQuestionCard(),
                  const SizedBox(height: AppSpacing.xxl),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'PUBLICAR DESAFIO',
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
    );
  }

  Widget _buildGeneralCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Informações Gerais', style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título do Desafio', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Descrição Breve', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Fuctura Coins Recompensa', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('2. Questão Vinculada', style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<QuestionType>(
                    value: _selectedType,
                    decoration: const InputDecoration(labelText: 'Tipo de Questão', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: QuestionType.multipleChoice, child: Text('Múltipla Escolha (Automático)')),
                      DropdownMenuItem(value: QuestionType.openText, child: Text('Texto Aberto (Subjetiva)')),
                    ],
                    onChanged: (v) => setState(() => _selectedType = v!),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<QuestionDifficulty>(
                    value: _selectedDifficulty,
                    decoration: const InputDecoration(labelText: 'Dificuldade', border: OutlineInputBorder()),
                    items: QuestionDifficulty.values.map((d) {
                      return DropdownMenuItem(value: d, child: Text(d.name.toUpperCase()));
                    }).toList(),
                    onChanged: (v) => setState(() => _selectedDifficulty = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _questionTextController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Enunciado da Questão', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
            ),
            if (_selectedType == QuestionType.multipleChoice) ...[
              const SizedBox(height: AppSpacing.lg),
              Text('Opções de Resposta (Marque a correta):', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: _correctOptionIndex,
                        onChanged: (v) => setState(() => _correctOptionIndex = v!),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _optionsControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Opção ${index + 1}',
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          validator: (v) => v!.isEmpty && _selectedType == QuestionType.multipleChoice ? 'Preencha a opção' : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else ...[
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade700),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Em questões subjetivas, o aluno escreve a resposta livremente. Você precisará avaliar manualmente depois para dar a recompensa.',
                        style: TextStyle(color: Colors.blue.shade800, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
