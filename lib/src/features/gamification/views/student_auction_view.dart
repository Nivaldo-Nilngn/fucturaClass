import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/models/gamification_model.dart';
import '../services/gamification_service.dart';

class StudentAuctionView extends StatefulWidget {
  final Auction auction;
  final int studentCoins;

  const StudentAuctionView({super.key, required this.auction, required this.studentCoins});

  @override
  State<StudentAuctionView> createState() => _StudentAuctionViewState();
}

class _StudentAuctionViewState extends State<StudentAuctionView> {
  final _service = GamificationService();
  final _bidController = TextEditingController();
  bool _isLoading = false;
  late int _minimumBid;

  @override
  void initState() {
    super.initState();
    _minimumBid = widget.auction.startingBid;
    _bidController.text = _minimumBid.toString();
  }

  Future<void> _placeBid() async {
    final amount = int.tryParse(_bidController.text);
    if (amount == null) return;

    if (amount > widget.studentCoins) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você não tem Fuctura Coins suficientes para esse lance!'), backgroundColor: Colors.red),
      );
      return;
    }

    if (amount < _minimumBid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seu lance deve ser maior ou igual a $_minimumBid.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final studentId = 'student_id'; // TODO: Pegar do AuthState

      await _service.placeBid(
        auctionId: widget.auction.id,
        studentId: studentId,
        amount: amount,
      );

      if (mounted) {
        _showSuccessAnimation();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao dar lance: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, val, child) {
                return Transform.scale(
                  scale: val,
                  child: child,
                );
              },
              child: const Icon(Icons.gavel, size: 100, color: Colors.amber),
            ),
            const SizedBox(height: 20),
            Text(
              'LANCE COMPUTADO!',
              style: GoogleFonts.nunitoSans(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Fecha dialog
                Navigator.pop(context, true); // Volta pra home
              },
              child: const Text('Incrível!'),
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
        title: Text('Leilão Fuctura', style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w900, color: const Color(0xFF7C5800))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF7C5800)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info do Aluno (Seus Coins)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFB800), width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        'Seu Saldo: ${widget.studentCoins} Fuctura Coins',
                        style: GoogleFonts.nunitoSans(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF7C5800)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Card do Leilão
                Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            widget.auction.photoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          children: [
                            Text(
                              widget.auction.product,
                              style: GoogleFonts.nunitoSans(fontSize: 28, fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              widget.auction.description,
                              style: GoogleFonts.nunitoSans(fontSize: 16, color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              'Lance Mínimo Exigido:',
                              style: GoogleFonts.nunitoSans(fontSize: 14, color: Colors.grey[600]),
                            ),
                            Text(
                              '$_minimumBid Coins',
                              style: GoogleFonts.nunitoSans(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.amber[700]),
                            ),
                            const SizedBox(height: AppSpacing.xl),

                            // Ação de Dar Lance
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _bidController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Seu Lance',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                      prefixIcon: Icon(Icons.monetization_on, color: Colors.amber),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  flex: 3,
                                  child: ElevatedButton.icon(
                                    onPressed: _isLoading ? null : _placeBid,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      backgroundColor: const Color(0xFFFF4B4B),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    icon: const Icon(Icons.gavel, color: Colors.white),
                                    label: _isLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : Text(
                                            'DAR LANCE!',
                                            style: GoogleFonts.nunitoSans(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
