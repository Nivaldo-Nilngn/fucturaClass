import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/gamification_model.dart';
import '../../auth/view_model/auth_view_model.dart';
import 'gamification_view_model.dart';

class AuctionState {
  final List<Auction> activeAuctions;
  final List<Bid> bids;

  AuctionState({
    this.activeAuctions = const [],
    this.bids = const [],
  });

  AuctionState copyWith({
    List<Auction>? activeAuctions,
    List<Bid>? bids,
  }) {
    return AuctionState(
      activeAuctions: activeAuctions ?? this.activeAuctions,
      bids: bids ?? this.bids,
    );
  }
}

class AuctionViewModel extends Notifier<AuctionState> {
  // Simulação de banco de dados
  final List<Auction> _dbAuctions = [
    Auction(
      id: 'auc_1',
      academyId: 'biblia3d',
      product: 'Teclado Mecânico Gamer',
      description: 'Lindo teclado mecânico RGB para turbinar seus códigos.',
      photoUrl: 'assets/teclado.png',
      startingBid: 1000,
      startsAt: DateTime.now().subtract(const Duration(days: 1)),
      endsAt: DateTime.now().add(const Duration(days: 2)),
      status: AuctionStatus.open,
    ),
  ];
  
  final List<Bid> _dbBids = [];

  @override
  AuctionState build() {
    return AuctionState(
      activeAuctions: List.unmodifiable(_dbAuctions),
      bids: List.unmodifiable(_dbBids),
    );
  }

  Future<String?> placeBid(String auctionId, int bidAmount) async {
    final user = ref.read(authViewModelProvider).user;
    if (user == null || user.role != UserRole.student) return 'Apenas alunos podem dar lances.';

    final auctionIndex = _dbAuctions.indexWhere((a) => a.id == auctionId);
    if (auctionIndex == -1) return 'Leilão não encontrado.';
    
    final auction = _dbAuctions[auctionIndex];
    if (auction.status != AuctionStatus.open) return 'Este leilão já foi encerrado.';
    
    if (DateTime.now().isAfter(auction.endsAt)) return 'O tempo para este leilão já acabou.';

    // Calcula o lance mínimo necessário
    final currentWinningBid = _dbBids.where((b) => b.id == auction.currentWinningBidId).firstOrNull;
    final minimumBid = currentWinningBid != null ? currentWinningBid.amount + 50 : auction.startingBid; // Incremento mínimo de 50
    
    if (bidAmount < minimumBid) {
      return 'O lance deve ser de pelo menos \$ $minimumBid F-Coins.';
    }

    final gamification = ref.read(gamificationViewModelProvider.notifier);
    
    // Verifica se o aluno tem saldo
    final hasBalance = gamification.subtractPoints(
      bidAmount, 
      TransactionType.auctionBid, 
      description: 'Lance bloqueado no leilão: ${auction.product}',
      relatedId: auction.id
    );

    if (!hasBalance) return 'Saldo insuficiente de F-Coins.';

    // Estorna (Escrow Refund) o lance do usuário anterior
    if (currentWinningBid != null) {
      // Simula estorno no banco de dados para o usuário perdedor
      // Num cenário real (Firebase), isso seria uma transação atômica
      // Como estamos mockando localmente para o usuário que não é o logado, 
      // precisamos injetar o ponto diretamente
      gamification.addPoints( // Nota: se o estorno for para o próprio usuário que está cobrindo seu próprio lance, ele recebe de volta
        currentWinningBid.amount, 
        TransactionType.auctionRefund, 
        description: 'Lance superado no leilão: ${auction.product}',
        relatedId: auction.id,
      );
      
      // Marca o lance antigo como inativo
      final oldBidIndex = _dbBids.indexWhere((b) => b.id == currentWinningBid.id);
      _dbBids[oldBidIndex] = _dbBids[oldBidIndex].copyWith(isActive: false);
    }

    // Registra o novo lance
    final newBid = Bid(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      auctionId: auction.id,
      studentId: user.id,
      amount: bidAmount,
      timestamp: DateTime.now(),
      isActive: true,
    );
    
    _dbBids.add(newBid);

    // Atualiza o leilão com o novo vencedor atual
    _dbAuctions[auctionIndex] = auction.copyWith(currentWinningBidId: newBid.id);

    // Atualiza a tela
    state = state.copyWith(
      activeAuctions: List.unmodifiable(_dbAuctions),
      bids: List.unmodifiable(_dbBids),
    );

    return null; // Sucesso
  }
}

final auctionViewModelProvider = NotifierProvider<AuctionViewModel, AuctionState>(() {
  return AuctionViewModel();
});
