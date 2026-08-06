import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/business_rule_model.dart';
import '../services/business_rules_service.dart';

class BusinessRuleFormDialog extends ConsumerStatefulWidget {
  final BusinessRule? ruleToEdit;

  const BusinessRuleFormDialog({super.key, this.ruleToEdit});

  @override
  ConsumerState<BusinessRuleFormDialog> createState() => _BusinessRuleFormDialogState();
}

class _BusinessRuleFormDialogState extends ConsumerState<BusinessRuleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String _selectedCategory = 'Geral';
  bool _isLoading = false;

  final List<String> _categories = [
    'Objetivo do Sistema',
    'Hierarquia de Usuários',
    'Estrutura Acadêmica',
    'Gamificação e Pontuação',
    'Desafios e Exercícios',
    'Leilão e Cashback',
    'Presença e Conteúdo',
    'Regras Gerais',
    'Geral'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.ruleToEdit?.title ?? '');
    _descriptionController = TextEditingController(text: widget.ruleToEdit?.description ?? '');
    
    if (widget.ruleToEdit != null) {
      if (_categories.contains(widget.ruleToEdit!.category)) {
        _selectedCategory = widget.ruleToEdit!.category;
      } else {
        // Se for uma categoria customizada
        _categories.add(widget.ruleToEdit!.category);
        _selectedCategory = widget.ruleToEdit!.category;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveRule() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final service = ref.read(businessRulesServiceProvider);
      
      if (widget.ruleToEdit != null) {
        final updatedRule = widget.ruleToEdit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
        );
        await service.updateRule(updatedRule);
      } else {
        final newRule = BusinessRule(
          id: '', // Firestore generates ID on add
          category: _selectedCategory,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await service.addRule(newRule);
      }
      
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.ruleToEdit != null;

    return Dialog(
      backgroundColor: const Color(0xFF1E1E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Editar Regra' : 'Nova Regra de Negócio',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE3E0F6),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                dropdownColor: const Color(0xFF292839),
                style: GoogleFonts.hankenGrotesk(color: const Color(0xFFE3E0F6)),
                decoration: InputDecoration(
                  labelText: 'Categoria (Bloco)',
                  labelStyle: GoogleFonts.hankenGrotesk(color: const Color(0xFF908FA0)),
                  filled: true,
                  fillColor: const Color(0xFF14142B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF464555)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF464555)),
                  ),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _titleController,
                style: GoogleFonts.hankenGrotesk(color: const Color(0xFFE3E0F6)),
                decoration: InputDecoration(
                  labelText: 'Título da Regra',
                  labelStyle: GoogleFonts.hankenGrotesk(color: const Color(0xFF908FA0)),
                  filled: true,
                  fillColor: const Color(0xFF14142B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF464555)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF464555)),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descriptionController,
                maxLines: 6,
                style: GoogleFonts.hankenGrotesk(color: const Color(0xFFE3E0F6)),
                decoration: InputDecoration(
                  labelText: 'Descrição / Conteúdo',
                  labelStyle: GoogleFonts.hankenGrotesk(color: const Color(0xFF908FA0)),
                  filled: true,
                  fillColor: const Color(0xFF14142B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF464555)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF464555)),
                  ),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.hankenGrotesk(color: const Color(0xFF908FA0)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveRule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E1AB),
                      foregroundColor: const Color(0xFF121221),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Color(0xFF121221), strokeWidth: 2),
                          )
                        : Text(
                            'Salvar',
                            style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.bold),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
