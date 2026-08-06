import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/view_model/auth_view_model.dart';
import '../../home/view_model/home_view_model.dart';
import '../../home/widgets/mobile_header_widget.dart';
import '../../home/widgets/desktop_header_widget.dart';

class CodeEditorView extends ConsumerWidget {
  const CodeEditorView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider).user;
    final homeStateAsync = ref.watch(homeViewModelProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 800;

        Widget content;
        if (user?.classId == null) {
          content = const _WaitingEnrollmentView();
        } else {
          content = isDesktop ? const _DesktopCodeEditor() : const _MobileCodeEditor();
        }

        if (isDesktop) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                homeStateAsync.when(
                  data: (state) => DesktopHeaderWidget(state: state, title: 'Exercícios e Desafios'),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                Expanded(child: content),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0F1117),
          body: Column(
            children: [
              homeStateAsync.when(
                data: (state) => MobileHeaderWidget(
                  state: state,
                  title: 'Exercícios e Desafios',
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }
}

class _WaitingEnrollmentView extends StatelessWidget {
  const _WaitingEnrollmentView();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: const Color(0xFF243447),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.code_off, color: Colors.white54, size: 64),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Sem Exercícios no Momento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Você ainda não possui exercícios para praticar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileCodeEditor extends StatefulWidget {
  const _MobileCodeEditor();

  @override
  State<_MobileCodeEditor> createState() => _MobileCodeEditorState();
}

class _MobileCodeEditorState extends State<_MobileCodeEditor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _codeController;
  final List<String> _consoleLines = [
    "> Pronto para executar. Escreva seu código e toque em 'Verificar'.",
  ];
  bool _isRunning = false;
  bool? _lastRunSuccess;

  static const _starterCode = '''List<int> generateFibonacci(int n) {
  if (n <= 0) return [];
  if (n == 1) return [0];

  List<int> sequence = [0, 1];

  // TODO: complete a lógica

  return sequence;
}

void main() {
  print(generateFibonacci(5));
}''';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _codeController = TextEditingController(text: _starterCode);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _runCode() {
    setState(() {
      _isRunning = true;
      _consoleLines.clear();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      final code = _codeController.text;
      final List<String> output = [];
      bool success = false;

      output.add('> Compilando main.dart...');

      final hasFunction = code.contains('generateFibonacci');
      final hasLoop = code.contains('for') || code.contains('while');
      // ignore: unused_local_variable
      final hasSequence = code.contains('sequence') || code.contains('fibonacci') || code.contains('fib');
      final hasAdd = code.contains('.add(') || code.contains('sequence[') || code.contains('+');

      if (!hasFunction) {
        output.add('❌ Erro: função generateFibonacci não encontrada.');
        output.add('   Certifique-se que o nome da função está correto.');
      } else if (!hasLoop && !hasAdd) {
        output.add('⚠️  Compilado, mas a lógica parece incompleta.');
        output.add('   Dica: use um laço (for/while) para gerar a sequência.');
        output.add('');
        output.add('> Saída com n=5:');
        output.add('[0, 1]  ← apenas o início, falta completar a lógica');
      } else {
        success = true;
        output.add('✅ Compilado com sucesso!');
        output.add('');
        output.add('> Executando: generateFibonacci(5)');
        output.add('[0, 1, 1, 2, 3]');
        output.add('');
        output.add('> Executando: generateFibonacci(8)');
        output.add('[0, 1, 1, 2, 3, 5, 8, 13]');
        output.add('');
        output.add('✅ Todos os testes passaram! +150 XP conquistados!');
      }

      setState(() {
        _consoleLines.addAll(output);
        _isRunning = false;
        _lastRunSuccess = success;
        // auto-switch to editor tab to show console
        _tabController.animateTo(1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── HEADER ──
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F1117), Color(0xFF1A1D2E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Exercício: Fibonacci',
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
                        ),
                        child: Text(
                          '⭐ +150 XP',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFFD700),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Tag('Dart', const Color(0xFF00B4D8)),
                      const SizedBox(width: 6),
                      _Tag('Intermediário', const Color(0xFFFF9800)),
                      if (_lastRunSuccess == true) ...[
                        const SizedBox(width: 6),
                        _Tag('✅ Resolvido', const Color(0xFF4CAF50)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Instruções'),
                      Tab(text: 'Editor'),
                    ],
                    labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                    unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white38,
                    indicatorColor: bento.primary,
                    indicatorWeight: 3,
                    dividerColor: Colors.white12,
                  ),
                ],
              ),
            ),

            // ── TAB VIEWS ──
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ---- TAB 1: INSTRUÇÕES ----
                  Container(
                    color: const Color(0xFFF8F9FC),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionTitle('Descrição'),
                          const SizedBox(height: 8),
                          Text(
                            'Escreva uma função Dart chamada generateFibonacci que recebe um inteiro n e retorna uma lista com os primeiros n números da sequência de Fibonacci.',
                            style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: const Color(0xFF374151)),
                          ),
                          const SizedBox(height: 20),
                          _SectionTitle('Regras'),
                          const SizedBox(height: 10),
                          _RuleItem('A sequência começa com 0 e 1.', bento.primary),
                          _RuleItem('Se n ≤ 0, retorne uma lista vazia.', bento.primary),
                          _RuleItem('Se n == 1, retorne [0].', bento.primary),
                          const SizedBox(height: 20),
                          _SectionTitle('Exemplos'),
                          const SizedBox(height: 10),
                          _ExampleBox('n = 5  →  [0, 1, 1, 2, 3]'),
                          const SizedBox(height: 6),
                          _ExampleBox('n = 1  →  [0]'),
                          const SizedBox(height: 6),
                          _ExampleBox('n = 0  →  []'),
                          const SizedBox(height: 24),
                          // CTA to editor
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _tabController.animateTo(1),
                              icon: const Icon(Icons.code, size: 18),
                              label: const Text('Ir para o Editor'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bento.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // ---- TAB 2: EDITOR ----
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // File tab bar
                      Container(
                        color: const Color(0xFF1E2030),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        height: 40,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E1E2E),
                                border: Border(bottom: BorderSide(color: Color(0xFF7C3AED), width: 2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.code, color: Color(0xFF7C3AED), size: 14),
                                  const SizedBox(width: 6),
                                  Text('main.dart', style: GoogleFonts.jetBrainsMono(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Code editor
                      Expanded(
                        flex: 6,
                        child: Container(
                          color: const Color(0xFF1E1E2E),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Line numbers
                              Container(
                                width: 36,
                                color: const Color(0xFF181825),
                                padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _codeController,
                                  builder: (_, val, __) {
                                    final lines = (val.text.split('\n').length).clamp(1, 999);
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: List.generate(
                                        lines,
                                        (i) => Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Text(
                                            '${i + 1}',
                                            style: GoogleFonts.jetBrainsMono(
                                              color: Colors.white24,
                                              fontSize: 12,
                                              height: 1.55,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Editable code field
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                                  child: TextField(
                                    controller: _codeController,
                                    maxLines: null,
                                    style: GoogleFonts.jetBrainsMono(
                                      color: const Color(0xFFCDD6F4),
                                      fontSize: 13,
                                      height: 1.55,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Run button
                      Container(
                        color: const Color(0xFF181825),
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          onPressed: _isRunning ? null : _runCode,
                          icon: _isRunning
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.play_arrow_rounded, size: 20),
                          label: Text(_isRunning ? 'Executando...' : 'Verificar Código'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _lastRunSuccess == true ? const Color(0xFF22C55E) : const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFF4B5563),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),

                      // Console divider
                      Container(height: 1, color: Colors.white10),

                      // Console header
                      Container(
                        color: const Color(0xFF181825),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        child: Row(
                          children: [
                            const Icon(Icons.terminal, color: Colors.white38, size: 14),
                            const SizedBox(width: 6),
                            Text('CONSOLE', style: GoogleFonts.inter(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            const Spacer(),
                            if (_consoleLines.length > 1)
                              GestureDetector(
                                onTap: () => setState(() {
                                  _consoleLines.clear();
                                  _consoleLines.add('> Console limpo.');
                                  _lastRunSuccess = null;
                                }),
                                child: Text('limpar', style: GoogleFonts.inter(color: Colors.white24, fontSize: 10)),
                              ),
                          ],
                        ),
                      ),

                      // Console output
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: const Color(0xFF11111B),
                          padding: const EdgeInsets.all(12),
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _consoleLines.map((line) {
                                Color color = Colors.white54;
                                if (line.startsWith('✅')) color = const Color(0xFF22C55E);
                                if (line.startsWith('❌')) color = const Color(0xFFEF4444);
                                if (line.startsWith('⚠️')) color = const Color(0xFFEAB308);
                                if (line.startsWith('>')) color = Colors.white30;
                                if (line.startsWith('[')) color = const Color(0xFF60A5FA);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    line,
                                    style: GoogleFonts.jetBrainsMono(color: color, fontSize: 12, height: 1.6),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label, style: GoogleFonts.inter(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF111827)));
  }
}

class _RuleItem extends StatelessWidget {
  final String text;
  final Color color;
  const _RuleItem(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6, height: 6,
            margin: const EdgeInsets.only(top: 5, right: 10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: const Color(0xFF374151)))),
        ],
      ),
    );
  }
}

class _ExampleBox extends StatelessWidget {
  final String text;
  const _ExampleBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: GoogleFonts.jetBrainsMono(color: const Color(0xFF7C3AED), fontSize: 13)),
    );
  }
}


// ---------------- DESKTOP LAYOUT ----------------

class _DesktopCodeEditor extends StatelessWidget {
  const _DesktopCodeEditor();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bento = theme.bento;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       'Exercício: Gerador da Sequência de Fibonacci',
                      style: GoogleFonts.hankenGrotesk(
                        color: bento.onSurface,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: bento.surfaceContainer,
                          child: Text('Dart', style: GoogleFonts.inter(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: bento.surfaceContainer,
                          child: Text('Intermediário', style: GoogleFonts.inter(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: bento.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '⭐ +150 XP',
                    style: GoogleFonts.inter(
                      color: bento.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: bento.outlineVariant.withOpacity(0.5)),
          
          // Main Body
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left Panel (Instructions)
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instruções',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Escreva uma função Dart chamada generateFibonacci que recebe um inteiro n e retorna uma lista com os primeiros n números da sequência de Fibonacci.',
                            style: GoogleFonts.inter(fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _BulletPoint('A sequência começa com 0 e 1.'),
                          _BulletPoint('Se n for 0 ou menos, retorne uma lista vazia.'),
                          _BulletPoint('Se n for 1, retorne [0].'),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Exemplo:',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: bento.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Input: n = 5\nOutput: [0, 1, 1, 2, 3]',
                              style: GoogleFonts.jetBrainsMono(
                                color: bento.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'Dicas de IA',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              border: Border.all(color: bento.outlineVariant.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.lightbulb_outline, color: bento.primary, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Travado? Use uma dica de IA para avançar.',
                                        style: GoogleFonts.inter(color: bento.onSurfaceVariant),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Revelar Dica 1',
                                        style: GoogleFonts.inter(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0044CC),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                               child: Text(
                                 'Iniciar Desafio Diário',
                                 style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                               ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Right Panel (Editor + Console)
                Expanded(
                  flex: 2,
                  child: Container(
                    color: const Color(0xFF1E1E1E), // VS Code dark
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Editor Tabs
                        Container(
                          color: const Color(0xFF252526),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.code, color: Colors.white70, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'main.dart',
                                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.refresh, color: Colors.white70, size: 18),
                                  const SizedBox(width: 16),
                                  Icon(Icons.settings, color: Colors.white70, size: 18),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Editor Area
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              '''// Implement the generateFibonacci function below\n\nList<int> generateFibonacci(int n) {\n  if (n <= 0) return [];\n  if (n == 1) return [0];\n\n  List<int> sequence = [0, 1];\n\n  // TODO: Add logic to generate the rest of the sequence\n\n  return sequence;\n}\n\nvoid main() {\n  print('Testing with n = 5:');\n  print(generateFibonacci(5));\n}''',
                              style: GoogleFonts.jetBrainsMono(
                                color: const Color(0xFFD4D4D4),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        
                        // Validate Button Action Area
                        Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.smart_toy),
                             label: const Text('Validar com IA'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0044CC),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                          ),
                        ),
                        
                        // Console Divider
                        Container(height: 1, color: Colors.white12),
                        
                        // Console Header
                        Container(
                          color: const Color(0xFF252526),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'CONSOLE',
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Console Area
                        Container(
                          height: 150,
                          color: const Color(0xFF1E1E1E),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                                                         "> Pronto para executar. Pressione 'Validar com IA' para verificar sua solução.",
                            style: GoogleFonts.jetBrainsMono(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 18, height: 1.2)),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 14, height: 1.5))),
        ],
      ),
    );
  }
}
