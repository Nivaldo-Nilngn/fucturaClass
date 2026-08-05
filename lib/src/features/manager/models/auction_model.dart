class Auction {
  final String id;
  final String title;
  final String description;
  final int minBid;
  final int increment;
  final DateTime? deadline;
  final int currentBid;
  final String? topBidder;
  final bool isActive;

  const Auction({
    required this.id,
    required this.title,
    required this.description,
    required this.minBid,
    required this.increment,
    this.deadline,
    this.currentBid = 0,
    this.topBidder,
    this.isActive = true,
  });

  Auction copyWith({
    String? id,
    String? title,
    String? description,
    int? minBid,
    int? increment,
    DateTime? deadline,
    int? currentBid,
    String? topBidder,
    bool? isActive,
  }) {
    return Auction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      minBid: minBid ?? this.minBid,
      increment: increment ?? this.increment,
      deadline: deadline ?? this.deadline,
      currentBid: currentBid ?? this.currentBid,
      topBidder: topBidder ?? this.topBidder,
      isActive: isActive ?? this.isActive,
    );
  }

  String get timeLeft {
    if (deadline == null) return '--';
    final now = DateTime.now();
    final diff = deadline!.difference(now);
    if (diff.isNegative) return 'Encerrado';
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    if (days > 0) return '${days}d ${hours}h';
    final minutes = diff.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}

class Redemption {
  final String id;
  final String prizeName;
  final String winnerName;
  final int points;
  final DateTime date;
  final RedemptionStatus status;

  const Redemption({
    required this.id,
    required this.prizeName,
    required this.winnerName,
    required this.points,
    required this.date,
    required this.status,
  });
}

enum RedemptionStatus { delivered, pending }