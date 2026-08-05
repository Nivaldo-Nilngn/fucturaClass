import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/gamification_model.dart';

class GamificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPoints({
    required String userId,
    required int amount,
    required TransactionType type,
    required String description,
    String? relatedId,
  }) async {
    final transaction = PointTransaction(
      id: const Uuid().v4(),
      userId: userId,
      amount: amount,
      type: type,
      timestamp: DateTime.now(),
      description: description,
      relatedId: relatedId,
    );

    // Save transaction
    await _firestore
        .collection('point_transactions')
        .doc(transaction.id)
        .set(transaction.toJson());

    // Update user's total points/coins in the users collection
    final userRef = _firestore.collection('users').doc(userId);
    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(userRef);
      if (snapshot.exists) {
        final currentCoins = snapshot.data()?['fucturaCoins'] ?? 0;
        tx.update(userRef, {'fucturaCoins': currentCoins + amount});
      }
    });
  }

  // --- RANKING / LEADERBOARD ---

  Future<List<Map<String, dynamic>>> getTopStudentsByClass(String classId, {int limit = 10}) async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'aluno')
        .where('classId', isEqualTo: classId)
        .orderBy('fucturaCoins', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // --- AUCTIONS (Leilões) ---

  Future<void> createAuction(Auction auction) async {
    await _firestore
        .collection('auctions')
        .doc(auction.id)
        .set(auction.toJson());
  }

  Future<List<Auction>> getAuctionsByAcademy(String academyId) async {
    final snapshot = await _firestore
        .collection('auctions')
        .where('academyId', isEqualTo: academyId)
        .orderBy('startsAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Auction.fromJson(doc.data())).toList();
  }

  /// Realiza um lance em um leilão de forma atômica usando Transaction
  Future<void> placeBid({
    required String auctionId,
    required String studentId,
    required int amount,
  }) async {
    final auctionRef = _firestore.collection('auctions').doc(auctionId);
    final userRef = _firestore.collection('users').doc(studentId);
    
    await _firestore.runTransaction((tx) async {
      final auctionDoc = await tx.get(auctionRef);
      final userDoc = await tx.get(userRef);

      if (!auctionDoc.exists) throw 'Leilão não encontrado.';
      if (!userDoc.exists) throw 'Usuário não encontrado.';

      final auction = Auction.fromJson(auctionDoc.data()!);
      
      if (auction.status != AuctionStatus.open) {
        throw 'Leilão está encerrado.';
      }

      final currentBalance = userDoc.data()?['fucturaCoins'] as int? ?? 0;
      if (currentBalance < amount) {
        throw 'Saldo insuficiente de Fuctura Coins.';
      }

      // 1. Verifica se o lance novo é maior que o lance inicial (se não houver lances) 
      //    ou maior que o lance vencedor atual
      int minimumRequiredBid = auction.startingBid;
      
      Bid? currentWinningBid;
      if (auction.currentWinningBidId != null) {
        final currentBidRef = _firestore.collection('bids').doc(auction.currentWinningBidId);
        final currentBidDoc = await tx.get(currentBidRef);
        if (currentBidDoc.exists) {
          currentWinningBid = Bid.fromJson(currentBidDoc.data()!);
          minimumRequiredBid = currentWinningBid.amount + 1;
        }
      }

      if (amount < minimumRequiredBid) {
        throw 'Seu lance deve ser de pelo menos $minimumRequiredBid Coins.';
      }

      // 2. Cria o novo lance
      final newBid = Bid(
        id: const Uuid().v4(),
        auctionId: auctionId,
        studentId: studentId,
        amount: amount,
        timestamp: DateTime.now(),
      );
      final newBidRef = _firestore.collection('bids').doc(newBid.id);

      // 3. Devolver os coins do ganhador anterior (Refund)
      if (currentWinningBid != null) {
        final previousWinnerRef = _firestore.collection('users').doc(currentWinningBid.studentId);
        final prevWinnerDoc = await tx.get(previousWinnerRef);
        
        if (prevWinnerDoc.exists) {
          final prevBalance = prevWinnerDoc.data()?['fucturaCoins'] as int? ?? 0;
          tx.update(previousWinnerRef, {'fucturaCoins': prevBalance + currentWinningBid.amount});
        }
        
        // Marca o lance antigo como inativo
        tx.update(_firestore.collection('bids').doc(currentWinningBid.id), {'isActive': false});
        
        // Registrar a transação de devolução (Opcional, faremos fora da transação principal para simplificar,
        // mas idealmente seria aqui)
      }

      // 4. Desconta os coins do NOVO ganhador
      tx.update(userRef, {'fucturaCoins': currentBalance - amount});

      // 5. Salva o novo lance
      tx.set(newBidRef, newBid.toJson());

      // 6. Atualiza o leilão com o novo ganhador
      tx.update(auctionRef, {
        'currentWinningBidId': newBid.id,
        'winnerId': studentId,
      });
    });
  }
}
