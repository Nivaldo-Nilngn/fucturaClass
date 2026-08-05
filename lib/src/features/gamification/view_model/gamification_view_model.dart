import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/gamification_model.dart';
import '../../auth/view_model/auth_view_model.dart';

class GamificationState {
  final int totalPoints;
  final List<PointTransaction> transactions;

  GamificationState({
    this.totalPoints = 0,
    this.transactions = const [],
  });

  GamificationState copyWith({
    int? totalPoints,
    List<PointTransaction>? transactions,
  }) {
    return GamificationState(
      totalPoints: totalPoints ?? this.totalPoints,
      transactions: transactions ?? this.transactions,
    );
  }
}

class GamificationViewModel extends Notifier<GamificationState> {
  // Simulação de banco de dados
  final List<PointTransaction> _dbTransactions = [];

  @override
  GamificationState build() {
    // Inicialmente carrega os pontos do usuário logado
    final user = ref.watch(authViewModelProvider).user;
    if (user == null) return GamificationState();

    final userTransactions = _dbTransactions.where((t) => t.userId == user.id).toList();
    final total = userTransactions.fold<int>(0, (sum, t) => sum + t.amount);

    return GamificationState(
      totalPoints: total,
      transactions: userTransactions..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
    );
  }

  void addPoints(int amount, TransactionType type, {String? description, String? relatedId}) {
    final user = ref.read(authViewModelProvider).user;
    if (user == null) return;

    final transaction = PointTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      amount: amount,
      type: type,
      timestamp: DateTime.now(),
      description: description,
      relatedId: relatedId,
    );

    _dbTransactions.add(transaction);
    
    // Atualiza estado local se o usuário atual for o beneficiado
    if (user.id == transaction.userId) {
      final newTransactions = [...state.transactions, transaction];
      final newTotal = state.totalPoints + amount;
      
      state = state.copyWith(
        totalPoints: newTotal,
        transactions: newTransactions..sort((a, b) => b.timestamp.compareTo(a.timestamp)),
      );
    }
  }

  bool subtractPoints(int amount, TransactionType type, {String? description, String? relatedId}) {
    if (state.totalPoints < amount) return false; // Saldo insuficiente

    addPoints(-amount, type, description: description, relatedId: relatedId);
    return true;
  }
}

final gamificationViewModelProvider = NotifierProvider<GamificationViewModel, GamificationState>(() {
  return GamificationViewModel();
});
