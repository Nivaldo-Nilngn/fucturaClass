import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../models/auction_model.dart';

class DesafiosView extends ConsumerStatefulWidget {
  const DesafiosView({super.key});

  @override
  ConsumerState<DesafiosView> createState() => _DesafiosViewState();
}

class _DesafiosViewState extends ConsumerState<DesafiosView> {
  final _titleController = TextEditingController();
  final _minBidController = TextEditingController();
  final _incrementController = TextEditingController();
  DateTime? _deadline;

  final List<Auction> _auctions = [
    Auction(
      id: '1',
      title: 'Camisa Fuctura Dev',
      description: 'Camisa exclusiva para desenvolvedores',
      minBid: 200,
      increment: 20,
      deadline: DateTime.now().add(const Duration(days: 2, hours: 4)),
      currentBid: 480,
      topBidder: 'Camila R.',
    ),
    Auction(
      id: '2',
      title: 'Caneca Terminal',
      description: 'Caneca com tema de terminal',
      minBid: 80,
      increment: 10,
      deadline: DateTime.now().add(const Duration(hours: 5, minutes: 12)),
      currentBid: 210,
      topBidder: 'João P.',
    ),
  ];

  final List<Redemption> _redemptions = [
    Redemption(
      id: '1',
      prizeName: 'Teclado Mecânico',
      winnerName: 'Lucas S.',
      points: 1200,
      date: DateTime(2023, 10, 12),
      status: RedemptionStatus.delivered,
    ),
    Redemption(
      id: '2',
      prizeName: 'Mousepad XL',
      winnerName: 'Mariana G.',
      points: 350,
      date: DateTime(2023, 10, 5),
      status: RedemptionStatus.pending,
    ),
    Redemption(
      id: '3',
      prizeName: 'Adesivos Pack',
      winnerName: 'Pedro H.',
      points: 150,
      date: DateTime(2023, 10, 1),
      status: RedemptionStatus.delivered,
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _minBidController.dispose();
    _incrementController.dispose();
    super.dispose();
  }

  void _createAuction() {
    if (_titleController.text.isEmpty || _minBidController.text.isEmpty) return;

    final newAuction = Auction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: 'Novo leilão',
      minBid: int.tryParse(_minBidController.text) ?? 100,
      increment: int.tryParse(_incrementController.text) ?? 10,
      deadline: _deadline,
    );

    setState(() {
      _auctions.add(newAuction);
      _titleController.clear();
      _minBidController.clear();
      _incrementController.clear();
      _deadline = null;
    });
  }

  void _deleteAuction(String id) {
    setState(() {
      _auctions.removeWhere((a) => a.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gestão de Prêmios e Leilões',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _buildFormSection()),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 2, child: _buildAuctionsSection()),
                  ],
                );
              }
              return Column(
                children: [
                  _buildFormSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildAuctionsSection(),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildHistorySection(),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return _BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.add_circle_outline,
            title: 'Cadastrar Novo Prêmio',
            color: const Color(0xFF00E1AB),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: _titleController,
            label: 'Nome do Prêmio',
            hint: 'Ex: Camisa Fuctura Dev',
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _minBidController,
                  label: 'Lance Mínimo (pts)',
                  hint: '200',
                  isNumber: true,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildTextField(
                  controller: _incrementController,
                  label: 'Incremento (+pts)',
                  hint: '20',
                  isNumber: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            controller: TextEditingController(),
            label: 'Data de Encerramento',
            hint: 'Selecione a data',
            suffixIcon: Icons.calendar_today,
            readOnly: true,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _deadline = date);
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _createAuction,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D5FEF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Criar Leilão',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuctionsSection() {
    return _BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader(
                icon: Icons.gavel,
                title: 'Leilões Ativos',
                color: const Color(0xFFC1C1FF),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF343344),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF464555)),
                ),
                child: Text(
                  '${_auctions.where((a) => a.isActive).length} Ativos',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: const Color(0xFFC7C4D7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_auctions.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'Nenhum leilão ativo',
                  style: TextStyle(color: const Color(0xFFC7C4D7), fontSize: 14),
                ),
              ),
            )
          else
            ..._auctions.map((auction) => _AuctionCard(
                  auction: auction,
                  onDelete: () => _deleteAuction(auction.id),
                )),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return _BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.history,
            title: 'Histórico de Resgates',
            color: const Color(0xFFFFDF9E),
          ),
          const SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Prêmio')),
                DataColumn(label: Text('Ganhador')),
                DataColumn(label: Text('Pontos')),
                DataColumn(label: Text('Data')),
                DataColumn(label: Text('Status')),
              ],
              rows: _redemptions.map((r) {
                final isDelivered = r.status == RedemptionStatus.delivered;
                return DataRow(cells: [
                  DataCell(Text(r.prizeName, style: const TextStyle(color: Color(0xFFE3E0F6)))),
                  DataCell(Text(r.winnerName, style: const TextStyle(color: const Color(0xFFC7C4D7)))),
                  DataCell(Text('${r.points} pts', style: GoogleFonts.jetBrainsMono(color: const Color(0xFFC1C1FF), fontSize: 13))),
                  DataCell(Text(
                    '${r.date.day.toString().padLeft(2, '0')}/${r.date.month.toString().padLeft(2, '0')}/${r.date.year}',
                    style: const TextStyle(color: Color(0xFFC7C4D7), fontSize: 13),
                  )),
                  DataCell(_buildStatusChip(isDelivered)),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isNumber = false,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: const Color(0xFFC7C4D7),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Color(0xFFE3E0F6)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: const Color(0xFF908FA0)),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: const Color(0xFF908FA0), size: 18) : null,
            filled: true,
            fillColor: const Color(0xFF1A1A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF464555)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF464555)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF00E1AB)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(bool isDelivered) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDelivered
            ? const Color(0xFF008261).withOpacity(0.2)
            : const Color(0xFFFABD00).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDelivered
              ? const Color(0xFF00E1AB).withOpacity(0.3)
              : const Color(0xFFFFDF9E).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isDelivered ? const Color(0xFF00E1AB) : const Color(0xFFFFDF9E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isDelivered ? 'Entregue' : 'Pendente',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 11,
              color: isDelivered ? const Color(0xFF00E1AB) : const Color(0xFFFFDF9E),
            ),
          ),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final Widget child;

  const _BentoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF464555)),
      ),
      child: child,
    );
  }
}

class _AuctionCard extends StatelessWidget {
  final Auction auction;
  final VoidCallback onDelete;

  const _AuctionCard({required this.auction, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2A),
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
                  auction.title,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFE3E0F6),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2E),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF464555)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.schedule, size: 12, color: Color(0xFFC7C4D7)),
                    const SizedBox(width: 4),
                    Text(
                      auction.timeLeft,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        color: const Color(0xFFC7C4D7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'lance mínimo ${auction.minBid} · incremento +${auction.increment}',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 12,
              color: const Color(0xFFC7C4D7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF464555), width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${auction.currentBid} pts',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFC1C1FF),
                      ),
                    ),
                    Text(
                      'maior lance: ${auction.topBidder ?? '--'}',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        color: const Color(0xFFC7C4D7),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.edit,
                      color: const Color(0xFFC7C4D7),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.close,
                      color: const Color(0xFFFFB4AB),
                      bgColor: const Color(0xFF93000A).withOpacity(0.2),
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    Color? bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}