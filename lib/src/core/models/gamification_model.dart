enum TransactionType {
  registration,
  firstChallenge,
  attendance,
  openExercise,
  answerExercise,
  createExercise,
  createQuestion,
  createChallenge,
  correctExercise,
  classParticipation,
  completeChallenge,
  readContent,
  auctionBid,
  auctionRefund,
  auctionWon,
  cashback,
  manualAdjustment
}

class PointTransaction {
  final String id;
  final String userId;
  final int amount;
  final TransactionType type;
  final DateTime timestamp;
  final String? relatedId;
  final String? description;

  const PointTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.timestamp,
    this.relatedId,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'relatedId': relatedId,
      'description': description,
    };
  }

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: json['amount'] as int,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.manualAdjustment,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      relatedId: json['relatedId'] as String?,
      description: json['description'] as String?,
    );
  }
}

enum AuctionStatus {
  open,
  closed,
}

class Auction {
  final String id;
  final String academyId;
  final String product;
  final String description;
  final String photoUrl;
  final int startingBid;
  final DateTime startsAt;
  final DateTime endsAt;
  final AuctionStatus status;
  final String? currentWinningBidId;
  final String? winnerId;

  const Auction({
    required this.id,
    required this.academyId,
    required this.product,
    required this.description,
    required this.photoUrl,
    required this.startingBid,
    required this.startsAt,
    required this.endsAt,
    this.status = AuctionStatus.open,
    this.currentWinningBidId,
    this.winnerId,
  });

  Auction copyWith({
    String? id,
    String? academyId,
    String? product,
    String? description,
    String? photoUrl,
    int? startingBid,
    DateTime? startsAt,
    DateTime? endsAt,
    AuctionStatus? status,
    String? currentWinningBidId,
    String? winnerId,
  }) {
    return Auction(
      id: id ?? this.id,
      academyId: academyId ?? this.academyId,
      product: product ?? this.product,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      startingBid: startingBid ?? this.startingBid,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      status: status ?? this.status,
      currentWinningBidId: currentWinningBidId ?? this.currentWinningBidId,
      winnerId: winnerId ?? this.winnerId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'academyId': academyId,
      'product': product,
      'description': description,
      'photoUrl': photoUrl,
      'startingBid': startingBid,
      'startsAt': startsAt.toIso8601String(),
      'endsAt': endsAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'currentWinningBidId': currentWinningBidId,
      'winnerId': winnerId,
    };
  }

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'] as String,
      academyId: json['academyId'] as String,
      product: json['product'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      startingBid: json['startingBid'] as int,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      status: AuctionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => AuctionStatus.open,
      ),
      currentWinningBidId: json['currentWinningBidId'] as String?,
      winnerId: json['winnerId'] as String?,
    );
  }
}

class Bid {
  final String id;
  final String auctionId;
  final String studentId;
  final int amount;
  final DateTime timestamp;
  final bool isActive;

  const Bid({
    required this.id,
    required this.auctionId,
    required this.studentId,
    required this.amount,
    required this.timestamp,
    this.isActive = true,
  });

  Bid copyWith({
    String? id,
    String? auctionId,
    String? studentId,
    int? amount,
    DateTime? timestamp,
    bool? isActive,
  }) {
    return Bid(
      id: id ?? this.id,
      auctionId: auctionId ?? this.auctionId,
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auctionId': auctionId,
      'studentId': studentId,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] as String,
      auctionId: json['auctionId'] as String,
      studentId: json['studentId'] as String,
      amount: json['amount'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
