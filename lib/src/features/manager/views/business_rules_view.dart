import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/business_rule_model.dart';
import '../services/business_rules_service.dart';
import '../widgets/business_rule_form_dialog.dart';

class BusinessRulesView extends ConsumerWidget {
  const BusinessRulesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rulesAsyncValue = ref.watch(businessRulesStreamProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121221),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2A),
        foregroundColor: const Color(0xFFE3E0F6),
        elevation: 0,
        title: Text(
          'Gerenciar Regras de Negócio',
          style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w700),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFF464555), height: 1.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ElevatedButton.icon(
              onPressed: () => _seedDatabase(context, ref),
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: Text('Gerar Padrão', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D5FEF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const BusinessRuleFormDialog(),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text('Nova Regra', style: GoogleFonts.hankenGrotesk(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E1AB),
                foregroundColor: const Color(0xFF121221),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          )
        ],
      ),
      body: rulesAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00E1AB))),
        error: (err, stack) => Center(
          child: Text(
            'Erro ao carregar regras:\n$err',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
        data: (rules) {
          if (rules.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.rule, size: 64, color: Color(0xFF464555)),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nenhuma regra de negócio cadastrada.',
                    style: GoogleFonts.hankenGrotesk(fontSize: 18, color: const Color(0xFFC7C4D7)),
                  ),
                ],
              ),
            );
          }

          // Agrupar regras por categoria
          final Map<String, List<BusinessRule>> groupedRules = {};
          for (var rule in rules) {
            groupedRules.putIfAbsent(rule.category, () => []).add(rule);
          }

          final categories = groupedRules.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryRules = groupedRules[category]!;

              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF464555)),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    collapsedIconColor: const Color(0xFF00E1AB),
                    iconColor: const Color(0xFF00E1AB),
                    title: Row(
                      children: [
                        const Icon(Icons.folder_open, color: Color(0xFF00E1AB), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          category,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE3E0F6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF464555),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${categoryRules.length}',
                            style: GoogleFonts.jetBrainsMono(fontSize: 12, color: const Color(0xFFC7C4D7)),
                          ),
                        )
                      ],
                    ),
                    children: categoryRules.map((rule) => _buildRuleItem(context, ref, rule)).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRuleItem(BuildContext context, WidgetRef ref, BusinessRule rule) {
    return Container(
      margin: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.md, bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  rule.title,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFFC7C4D7), size: 20),
                    tooltip: 'Editar',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => BusinessRuleFormDialog(ruleToEdit: rule),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFFFF5C5C), size: 20),
                    tooltip: 'Excluir',
                    onPressed: () => _confirmDelete(context, ref, rule),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            rule.description,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              color: const Color(0xFF908FA0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, BusinessRule rule) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: Text('Excluir Regra?', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
        content: Text(
          'Tem certeza que deseja excluir "${rule.title}"?\nEsta ação não pode ser desfeita.',
          style: GoogleFonts.hankenGrotesk(color: const Color(0xFFC7C4D7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFFC7C4D7))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5C5C)),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(businessRulesServiceProvider).deleteRule(rule.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Regra excluída com sucesso!'), backgroundColor: Color(0xFF00E1AB)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  Future<void> _seedDatabase(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2E),
        title: Text('Gerar Regras Padrão?', style: GoogleFonts.hankenGrotesk(color: Colors.white)),
        content: Text(
          'Isso irá inserir todas as regras de negócio base do sistema automaticamente no banco de dados. Deseja continuar?',
          style: GoogleFonts.hankenGrotesk(color: const Color(0xFFC7C4D7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFFC7C4D7))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E1AB)),
            child: const Text('Gerar', style: TextStyle(color: Color(0xFF121221))),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final service = ref.read(businessRulesServiceProvider);
    
    final defaultRules = [
      BusinessRule(id: '', category: 'Objetivo do Sistema', title: 'Objetivo Principal', description: 'Gerenciar academias, cursos, turmas, professores, alunos, exercícios, desafios, presença, pontuação (gamificação), leilões, conteúdos ministrados e relatórios administrativos.\nTodo o sistema será baseado em gamificação.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Hierarquia de Usuários', title: 'Nível 1 – Administrador', description: 'Possui acesso total ao sistema.\nPermissões: Cadastrar usuários, Editar qualquer cadastro, Excluir registros, Criar Academias, Unidades e Turmas, Vincular Professores, Alterar Pontuação, Corrigir erros, Abrir e Encerrar Leilões, Fechar Turmas, Gerenciar Permissões.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Hierarquia de Usuários', title: 'Nível 2 – Secretário', description: 'Responsável pela gestão acadêmica.\nPermissões: Cadastrar alunos/professores, Criar turmas, Matricular alunos, Registrar presença, Abrir leilões, Fechar turmas, Consultar relatórios, poderá alterar pontuação manualmente.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Hierarquia de Usuários', title: 'Nível 3 – Professor', description: 'Cada professor só poderá acessar as turmas em que estiver vinculado.\nPermissões: Registrar presença, Criar exercícios/desafios/perguntas, Corrigir respostas, Registrar conteúdo da aula, Visualizar extrato de pontuação dos alunos da sua turma.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Hierarquia de Usuários', title: 'Nível 4 – Aluno', description: 'Permissões: Visualizar sua turma, Aceitar desafios, Responder exercícios, Participar dos leilões, Consultar extrato.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Estrutura Acadêmica', title: 'Academias e Módulos', description: 'O sistema possuirá várias academias (ex: Java, Python, Bíblia3D). Cada academia poderá possuir diversos módulos (ex: Java Básico, Java POO).', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Estrutura Acadêmica', title: 'Unidades e Turmas', description: 'Turmas organizadas por unidade (Nome, Endereço, Responsável). Cada turma pertence obrigatoriamente a uma Academia, Unidade e Professor. Modalidades: Presencial, Online, Híbrida.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Gamificação e Pontuação', title: 'Tabela Oficial de Pontos', description: 'Cadastro do Aluno: +50\nPrimeiro Desafio: +95\nRegistrar Presença: +35\nAbrir Exercício: +25\nProfessor Criar Exercício/Pergunta: +10\nProfessor Criar Desafio: +20\nProfessor Corrigir Exercício: +5\nParticipação em Aula: +20\nLeitura de Conteúdo: +15', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Gamificação e Pontuação', title: 'Extrato de Pontos', description: 'Todas as movimentações gerarão um registro no Extrato (ex: Presença +35, Leilão -800). Tudo ficará registrado e nenhuma movimentação poderá ser apagada (Auditoria completa).', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Desafios e Exercícios', title: 'Ciclo do Desafio', description: 'Professor cria -> Aluno aceita -> Aluno responde -> Professor corrige -> Sistema gera pontos. Perguntas podem ser reutilizadas do Banco de Perguntas.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Leilão e Cashback', title: 'Fluxo de Leilão', description: 'Secretaria abre o leilão. Aluno oferece lance -> Sistema bloqueia pontos. Se outro aluno cobre -> Sistema devolve pontos ao anterior. Vence o maior lance. Enquanto aberto, aluno pode desistir.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Leilão e Cashback', title: 'Cashback do Vencedor', description: 'Caso o aluno vença o leilão, o sistema desconta definitivamente os pontos, mas o aluno receberá automaticamente 10% de cashback (ex: Lance de 8000, ganha 800).', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Presença e Conteúdo', title: 'Registro de Aulas', description: 'Bíblia3D: Aluno pode registrar própria presença, mas se prof registrar antes, aluno ganha os pontos. Java/Python: Registrar Entrada e Saída. O professor deve registrar o Conteúdo Ministrado após cada aula.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      BusinessRule(id: '', category: 'Regras Gerais', title: 'Diretrizes Principais', description: 'CPF é único. Login com CPF e Senha. Turmas fechadas não permitem alterações de nota/presença (só Admin reabre). Auditoria completa de todas as ações no sistema sem exclusão.', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    ];

    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gerando regras...'), backgroundColor: Color(0xFF5D5FEF)),
        );
      }
      
      for (var rule in defaultRules) {
        await service.addRule(rule);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Regras inseridas com sucesso!'), backgroundColor: Color(0xFF00E1AB)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar regras: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

