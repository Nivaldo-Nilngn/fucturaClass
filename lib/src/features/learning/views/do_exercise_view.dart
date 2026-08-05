import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/learning_model.dart';
import '../../../core/models/gamification_model.dart';
import '../../gamification/services/gamification_service.dart';

class DoExerciseView extends StatefulWidget {
  final Challenge challenge;
  final Question question;

  const DoExerciseView({super.key, required this.challenge, required this.question});

  @override
  State<DoExerciseView> createState() => _DoExerciseViewState();
}

class _DoExerciseViewState extends State<DoExerciseView> {
  final _gamificationService = GamificationService();
  bool _isLoading = false;

  // Para múltipla escolha
  int? _selectedOptionIndex;
  
  // Para texto livre
  final _textController = TextEditingController();

  Future<void> _submitAnswer() async {
    setState(() => _isLoading = true);

    try {
      final studentId = 'student_id'; // TODO: pegar do AuthState

      if (widget.question.type == QuestionType.multipleChoice) {
        if (_selectedOptionIndex == null) {
          throw 'Selecione uma opção!';
        }
        
        final selectedAnswer = widget.question.options![_selectedOptionIndex!];
        
        if (selectedAnswer == widget.question.correctAnswer) {
          // Acertou!
          await _gamificationService.addPoints(
            userId: studentId,
            amount: widget.challenge.points,
            type: TransactionType.completeChallenge,
            description: 'Acertou o desafio: ${widget.challenge.title}',
            relatedId: widget.challenge.id,
          );
          
          if (mounted) {
            _showSuccessDialog();
          }
        } else {
          // Errou
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ops, resposta incorreta! Tente novamente.'), backgroundColor: Colors.orange),
            );
          }
        }
      } else {
        // Texto livre
        if (_textController.text.trim().isEmpty) {
          throw 'Escreva sua resposta!';
        }
        
        // Em um app real, salvaríamos a resposta para o professor avaliar.
        // Como o foco é MVP, apenas mostramos sucesso provisório.
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resposta enviada ao professor para avaliação!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 64),
            const SizedBox(height: 16),
            Text(
              'Parabéns!',
              style: GoogleFonts.nunitoSans(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Você acertou e ganhou ${widget.challenge.points} Fuctura Coins!',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fechar dialog
                Navigator.pop(context, true); // Voltar para tela anterior
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Sensacional!', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8E2),
      appBar: AppBar(
        title: Text('Missão do Dia', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w900, color: const Color(0xFF7C5800))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF7C5800)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            children: [
              _buildChallengeHeader(),
              const SizedBox(height: AppSpacing.xl),
              _buildQuestionArea(),
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: const Color(0xFFF59E0B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'ENVIAR RESPOSTA',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
              const SizedBox(width: 8),
              Text(
                'VALENDO ${widget.challenge.points} COINS',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.challenge.title,
            style: GoogleFonts.nunitoSans(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.challenge.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.challenge.description,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionArea() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.text,
            style: GoogleFonts.nunitoSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          if (widget.question.type == QuestionType.multipleChoice && widget.question.options != null)
            ...List.generate(widget.question.options!.length, (index) {
              final isSelected = _selectedOptionIndex == index;
              final optionText = widget.question.options![index];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: InkWell(
                  onTap: () => setState(() => _selectedOptionIndex = index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            optionText,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
          else
            TextFormField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Escreva sua resposta aqui...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 2),
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
              ),
            ),
        ],
      ),
    );
  }
}
