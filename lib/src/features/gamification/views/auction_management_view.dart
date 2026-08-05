import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/gamification_model.dart';
import '../services/gamification_service.dart';

class AuctionManagementView extends StatefulWidget {
  final String academyId; // O leilão pertence à academia toda
  const AuctionManagementView({super.key, required this.academyId});

  @override
  State<AuctionManagementView> createState() => _AuctionManagementViewState();
}

class _AuctionManagementViewState extends State<AuctionManagementView> {
  final _service = GamificationService();
  bool _isLoading = true;
  List<Auction> _auctions = [];

  // Form
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _descController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _startingBidController = TextEditingController();
  
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _loadAuctions();
  }

  Future<void> _loadAuctions() async {
    setState(() => _isLoading = true);
    try {
      _auctions = await _service.getAuctionsByAcademy(widget.academyId);
    } catch (e) {
      debugPrint('Erro ao carregar leilões: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createAuction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);
    try {
      final startingBid = int.tryParse(_startingBidController.text) ?? 100;
      
      final auction = Auction(
        id: const Uuid().v4(),
        academyId: widget.academyId,
        product: _productController.text.trim(),
        description: _descController.text.trim(),
        photoUrl: _photoUrlController.text.trim(),
        startingBid: startingBid,
        startsAt: DateTime.now(),
        endsAt: DateTime.now().add(const Duration(days: 7)), // 1 semana padrão
        status: AuctionStatus.open,
      );

      await _service.createAuction(auction);
      
      _productController.clear();
      _descController.clear();
      _photoUrlController.clear();
      _startingBidController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Leilão criado com sucesso!')),
        );
        Navigator.pop(context); // Fechar modal de criação
        _loadAuctions(); // Recarregar lista
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  void _showCreateModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Novo Leilão', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _productController,
                    decoration: const InputDecoration(labelText: 'Nome do Produto/Brinde', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Descrição Breve', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _photoUrlController,
                    decoration: const InputDecoration(labelText: 'URL da Foto (Link da Web)', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _startingBidController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Lance Inicial (Coins)', border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _isCreating ? null : _createAuction,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: const Text('Criar Leilão', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Leilões', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo Leilão',
            onPressed: _showCreateModal,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _auctions.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum leilão criado para esta unidade.',
                      style: GoogleFonts.nunitoSans(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      mainAxisSpacing: AppSpacing.lg,
                      crossAxisSpacing: AppSpacing.lg,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _auctions.length,
                    itemBuilder: (context, index) {
                      final auction = _auctions[index];
                      return _buildAuctionCard(auction);
                    },
                  ),
      ),
    );
  }

  Widget _buildAuctionCard(Auction auction) {
    final isOpen = auction.status == AuctionStatus.open;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagem do Produto
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                auction.photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Detalhes
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOpen ? Colors.green.shade100 : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isOpen ? 'ABERTO' : 'FECHADO',
                          style: TextStyle(
                            color: isOpen ? Colors.green.shade800 : Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        'Lance Início: ${auction.startingBid}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    auction.product,
                    style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    auction.description,
                    style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Lance Vencedor
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text('Maior Lance Atual', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        Text(
                          auction.currentWinningBidId != null ? 'ID: ...${auction.currentWinningBidId!.substring(0, 5)}' : 'Nenhum Lance',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
