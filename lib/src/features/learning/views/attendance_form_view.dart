import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/user_model.dart';
import '../../manager/models/course_model.dart';
import '../../../core/models/learning_model.dart';
import '../../../core/models/academy_model.dart';
import '../../../core/models/gamification_model.dart';
import '../services/attendance_service.dart';
import '../../gamification/services/gamification_service.dart';

class AttendanceFormView extends StatefulWidget {
  final Turma turma;
  final List<AppUser> alunos;

  const AttendanceFormView({super.key, required this.turma, required this.alunos});

  @override
  State<AttendanceFormView> createState() => _AttendanceFormViewState();
}

class _AttendanceFormViewState extends State<AttendanceFormView> {
  final _service = AttendanceService();
  final _gamificationService = GamificationService(); // Para recompensar alunos presentes
  bool _isLoading = false;

  // Mapa para guardar presença: alunoId -> true/false
  final Map<String, bool> _presenceMap = {};
  ClassModality _modality = ClassModality.presential;

  @override
  void initState() {
    super.initState();
    // Inicia todos como Faltantes (false) por precaução ou Presentes (true) para facilitar
    for (var aluno in widget.alunos) {
      _presenceMap[aluno.id] = true;
    }
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      final now = DateTime.now();
      final List<Attendance> attendances = [];

      for (var aluno in widget.alunos) {
        final isPresent = _presenceMap[aluno.id] ?? false;

        // Apenas salva a presença se foi marcado, ou salva como falta (depende da regra).
        // Aqui vamos salvar o registro para o relatório futuro
        attendances.add(
          Attendance(
            id: const Uuid().v4(),
            classId: widget.turma.id,
            studentId: aluno.id,
            date: now,
            time: now,
            registeredBy: 'professor_id', // TODO: Pegar ID do professor logado
            modality: _modality,
          ),
        );

        if (isPresent) {
          // Recompensar o aluno por comparecer
          await _gamificationService.addPoints(
            userId: aluno.id,
            amount: 50, // 50 Fuctura Coins por aula
            type: TransactionType.attendance,
            description: 'Presença na aula do dia ${now.day}/${now.month}',
            relatedId: widget.turma.id,
          );
        }
      }

      await _service.registerMultiple(attendances);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presença salva e Fuctura Coins distribuídos!')),
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
        title: Text('Diário de Classe', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Turma: ${widget.turma.nome}',
                  style: GoogleFonts.nunitoSans(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                DropdownButton<ClassModality>(
                  value: _modality,
                  items: ClassModality.values.map((mod) {
                    return DropdownMenuItem(
                      value: mod,
                      child: Text(mod.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _modality = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListView.separated(
                  itemCount: widget.alunos.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final aluno = widget.alunos[index];
                    final isPresent = _presenceMap[aluno.id] ?? false;

                    return SwitchListTile(
                      title: Text(aluno.name, style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600)),
                      subtitle: Text('CPF: ${aluno.cpf}'),
                      value: isPresent,
                      activeColor: Colors.green,
                      inactiveTrackColor: Colors.red.shade100,
                      inactiveThumbColor: Colors.red,
                      onChanged: (val) {
                        setState(() {
                          _presenceMap[aluno.id] = val;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'SALVAR PRESENÇA',
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
    );
  }
}
