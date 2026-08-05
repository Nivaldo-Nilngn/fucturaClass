enum AttendanceStatus { present, absent, current, pending, future }

class Attendance {
  final String label; // "S1", "S2"
  final AttendanceStatus status;

  const Attendance({required this.label, required this.status});
}

class RankingUser {
  final int rank;
  final String initials;
  final String name;
  final int points;
  final bool isCurrentUser;

  const RankingUser({
    required this.rank,
    required this.initials,
    required this.name,
    required this.points,
    this.isCurrentUser = false,
  });
}

class AuctionItem {
  final String title;
  final int minBid;
  final int increment;
  final String timeLeft;
  final int currentBid;
  final String topBidder; // E.g., "Camila R." or "Você está ganhando"
  final bool isWinning;

  const AuctionItem({
    required this.title,
    required this.minBid,
    required this.increment,
    required this.timeLeft,
    required this.currentBid,
    required this.topBidder,
    required this.isWinning,
  });
}

class ChecklistItem {
  final String title;
  final bool isCompleted;

  const ChecklistItem({required this.title, required this.isCompleted});
}

class HomeState {
  // HUD
  final String firstName;
  final String fullName;
  final String initials;
  final String badge1;
  final String badge2;
  final int points;
  final int streak;
  final int rankPosition;

  // Module Progress
  final String moduleName;
  final String moduleSubtitle;
  final int moduleProgressPercent;

  // Next Class
  final String nextClassTopic;
  final String nextClassDescription;
  final String nextClassCodeSnippet; // Simple string to represent code snippet if any
  final String nextClassDate;
  final String nextClassTime;
  final String nextClassLocation;

  // Components
  final List<RankingUser> ranking;
  final List<Attendance> attendanceHistory;
  final String attendanceMessage;
  final String attendanceMessageHighlight; // E.g. "Aula S11"
  final String attendanceMessageStatus; // E.g. "aguardando confirmação"
  
  final List<ChecklistItem> checklist;
  final List<AuctionItem> auctions;

  const HomeState({
    required this.firstName,
    required this.fullName,
    required this.initials,
    required this.badge1,
    required this.badge2,
    required this.points,
    required this.streak,
    required this.rankPosition,
    required this.moduleName,
    required this.moduleSubtitle,
    required this.moduleProgressPercent,
    required this.nextClassTopic,
    required this.nextClassDescription,
    required this.nextClassCodeSnippet,
    required this.nextClassDate,
    required this.nextClassTime,
    required this.nextClassLocation,
    required this.ranking,
    required this.attendanceHistory,
    required this.attendanceMessage,
    required this.attendanceMessageHighlight,
    required this.attendanceMessageStatus,
    required this.checklist,
    required this.auctions,
  });

  factory HomeState.initial() {
    return const HomeState(
      firstName: '',
      fullName: '',
      initials: '',
      badge1: '',
      badge2: '',
      points: 0,
      streak: 0,
      rankPosition: 0,
      moduleName: '',
      moduleSubtitle: '',
      moduleProgressPercent: 0,
      nextClassTopic: '',
      nextClassDescription: '',
      nextClassCodeSnippet: '',
      nextClassDate: '',
      nextClassTime: '',
      nextClassLocation: '',
      ranking: [],
      attendanceHistory: [],
      attendanceMessage: '',
      attendanceMessageHighlight: '',
      attendanceMessageStatus: '',
      checklist: [],
      auctions: [],
    );
  }

  HomeState copyWith({
    String? firstName,
    String? fullName,
    String? initials,
    String? badge1,
    String? badge2,
    int? points,
    int? streak,
    int? rankPosition,
    String? moduleName,
    String? moduleSubtitle,
    int? moduleProgressPercent,
    String? nextClassTopic,
    String? nextClassDescription,
    String? nextClassCodeSnippet,
    String? nextClassDate,
    String? nextClassTime,
    String? nextClassLocation,
    List<RankingUser>? ranking,
    List<Attendance>? attendanceHistory,
    String? attendanceMessage,
    String? attendanceMessageHighlight,
    String? attendanceMessageStatus,
    List<ChecklistItem>? checklist,
    List<AuctionItem>? auctions,
  }) {
    return HomeState(
      firstName: firstName ?? this.firstName,
      fullName: fullName ?? this.fullName,
      initials: initials ?? this.initials,
      badge1: badge1 ?? this.badge1,
      badge2: badge2 ?? this.badge2,
      points: points ?? this.points,
      streak: streak ?? this.streak,
      rankPosition: rankPosition ?? this.rankPosition,
      moduleName: moduleName ?? this.moduleName,
      moduleSubtitle: moduleSubtitle ?? this.moduleSubtitle,
      moduleProgressPercent: moduleProgressPercent ?? this.moduleProgressPercent,
      nextClassTopic: nextClassTopic ?? this.nextClassTopic,
      nextClassDescription: nextClassDescription ?? this.nextClassDescription,
      nextClassCodeSnippet: nextClassCodeSnippet ?? this.nextClassCodeSnippet,
      nextClassDate: nextClassDate ?? this.nextClassDate,
      nextClassTime: nextClassTime ?? this.nextClassTime,
      nextClassLocation: nextClassLocation ?? this.nextClassLocation,
      ranking: ranking ?? this.ranking,
      attendanceHistory: attendanceHistory ?? this.attendanceHistory,
      attendanceMessage: attendanceMessage ?? this.attendanceMessage,
      attendanceMessageHighlight: attendanceMessageHighlight ?? this.attendanceMessageHighlight,
      attendanceMessageStatus: attendanceMessageStatus ?? this.attendanceMessageStatus,
      checklist: checklist ?? this.checklist,
      auctions: auctions ?? this.auctions,
    );
  }
}
