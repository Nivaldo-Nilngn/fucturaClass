import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/gamification_model.dart';

class FirestoreGamificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Recuperar Saldo Total de um Usuário
  Future<int> getUserBalance(String userId) async {
    final doc = await _firestore.collection('wallets').doc(userId).get();
    if (doc.exists) {
      return doc.data()?['balance'] ?? 0;
    }
    return 0;
  }

  // Registrar Transação (Ganhos ou Gastos) e atualizar saldo
  Future<void> recordTransaction(PointTransaction transaction) async {
    final batch = _firestore.batch();
    
    // 1. Salva a transação na subcoleção do usuário para histórico
    final transactionRef = _firestore
        .collection('wallets')
        .doc(transaction.userId)
        .collection('transactions')
        .doc(transaction.id);
        
    batch.set(transactionRef, transaction.toJson());

    // 2. Atualiza o saldo total (Incremento atômico)
    final walletRef = _firestore.collection('wallets').doc(transaction.userId);
    batch.set(
      walletRef, 
      {'balance': FieldValue.increment(transaction.amount)}, 
      SetOptions(merge: true)
    );

    await batch.commit();
  }

  // Escrow de Leilão - Lógica Atômica para cobrir lances
  Future<void> placeAuctionBid(Bid newBid, Bid? previousWinningBid) async {
    final batch = _firestore.batch();
    
    // 1. Registra o novo lance
    final newBidRef = _firestore.collection('auctions').doc(newBid.auctionId).collection('bids').doc(newBid.id);
    batch.set(newBidRef, newBid.toJson());

    // 2. Subtrai o saldo do novo apostador
    final newWalletRef = _firestore.collection('wallets').doc(newBid.studentId);
    batch.set(
      newWalletRef,
      {'balance': FieldValue.increment(-newBid.amount)},
      SetOptions(merge: true)
    );

    // 3. Devolve (Estorna) o saldo do apostador anterior que foi superado
    if (previousWinningBid != null && previousWinningBid.studentId != newBid.studentId) {
      final prevWalletRef = _firestore.collection('wallets').doc(previousWinningBid.studentId);
      batch.set(
        prevWalletRef,
        {'balance': FieldValue.increment(previousWinningBid.amount)},
        SetOptions(merge: true)
      );
      
      // Invalida o lance antigo
      final prevBidRef = _firestore.collection('auctions').doc(newBid.auctionId).collection('bids').doc(previousWinningBid.id);
      batch.update(prevBidRef, {'isActive': false});
    }

    // 4. Atualiza o Leilão com o novo vencedor atual
    final auctionRef = _firestore.collection('auctions').doc(newBid.auctionId);
    batch.update(auctionRef, {
      'currentWinningBidId': newBid.id,
      'currentWinnerId': newBid.studentId,
    });

    await batch.commit();
  }
}
