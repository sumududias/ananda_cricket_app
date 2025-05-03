import '../../core/config/api_config.dart';

class Player {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime dob;
  final String? battingStyle;
  final String? bowlingStyle;
  final String? primaryRole;
  final String? playerClass;
  final int? yearJoined;
  final String? _photo; // Private field for raw photo URL
  final bool isActive;
  final int? userId;
  final BattingStats? battingStats;
  final BowlingStats? bowlingStats;
  final FieldingStats? fieldingStats;
  final int totalMatches;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dob,
    this.battingStyle,
    this.bowlingStyle,
    this.primaryRole,
    this.playerClass,
    this.yearJoined,
    String? photo,
    required this.isActive,
    this.userId,
    this.battingStats,
    this.bowlingStats,
    this.fieldingStats,
    required this.totalMatches,
  }) : _photo = photo;

  // Getter for the full photo URL
  String? get photo => ApiConfig.getFullMediaUrl(_photo);

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : DateTime.now(),
      battingStyle: json['batting_style'],
      bowlingStyle: json['bowling_style'],
      primaryRole: json['primary_role'],
      playerClass: json['player_class'],
      yearJoined: json['year_joined'],
      photo: json['photo'],
      isActive: json['is_active'] ?? false,
      userId: json['user'],
      battingStats: json['batting_stats'] != null
          ? BattingStats.fromJson(json['batting_stats'])
          : null,
      bowlingStats: json['bowling_stats'] != null
          ? BowlingStats.fromJson(json['bowling_stats'])
          : null,
      fieldingStats: json['fielding_stats'] != null
          ? FieldingStats.fromJson(json['fielding_stats'])
          : null,
      totalMatches: json['total_matches'] ?? 0,
    );
  }

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'dob': dob.toIso8601String(),
        'batting_style': battingStyle,
        'bowling_style': bowlingStyle,
        'primary_role': primaryRole,
        'player_class': playerClass,
        'year_joined': yearJoined,
        'photo': _photo,
        'is_active': isActive,
        'user': userId,
        'batting_stats': battingStats?.toJson(),
        'bowling_stats': bowlingStats?.toJson(),
        'fielding_stats': fieldingStats?.toJson(),
        'total_matches': totalMatches,
      };
}

class BattingStats {
  final int matches;
  final int innings;
  final int notOuts;
  final int runs;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final double average;
  final double strikeRate;
  final int highestScore;

  BattingStats({
    required this.matches,
    required this.innings,
    required this.notOuts,
    required this.runs,
    required this.ballsFaced,
    required this.fours,
    required this.sixes,
    required this.average,
    required this.strikeRate,
    required this.highestScore,
  });

  factory BattingStats.fromJson(Map<String, dynamic> json) {
    return BattingStats(
      matches: json['matches'] ?? 0,
      innings: json['innings'] ?? 0,
      notOuts: json['not_outs'] ?? 0,
      runs: json['runs'] ?? 0,
      ballsFaced: json['balls_faced'] ?? 0,
      fours: json['fours'] ?? 0,
      sixes: json['sixes'] ?? 0,
      average: (json['average'] ?? 0).toDouble(),
      strikeRate: (json['strike_rate'] ?? 0).toDouble(),
      highestScore: json['highest_score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'matches': matches,
        'innings': innings,
        'not_outs': notOuts,
        'runs': runs,
        'balls_faced': ballsFaced,
        'fours': fours,
        'sixes': sixes,
        'average': average,
        'strike_rate': strikeRate,
        'highest_score': highestScore,
      };
}

class BowlingStats {
  final int matches;
  final int innings;
  final double overs;
  final int runs;
  final int wickets;
  final double average;
  final double economy;
  final double strikeRate;
  final String bestBowling;

  BowlingStats({
    required this.matches,
    required this.innings,
    required this.overs,
    required this.runs,
    required this.wickets,
    required this.average,
    required this.economy,
    required this.strikeRate,
    required this.bestBowling,
  });

  factory BowlingStats.fromJson(Map<String, dynamic> json) {
    return BowlingStats(
      matches: json['matches'] ?? 0,
      innings: json['innings'] ?? 0,
      overs: (json['overs'] ?? 0).toDouble(),
      runs: json['runs'] ?? 0,
      wickets: json['wickets'] ?? 0,
      average: (json['average'] ?? 0).toDouble(),
      economy: (json['economy'] ?? 0).toDouble(),
      strikeRate: (json['strike_rate'] ?? 0).toDouble(),
      bestBowling: json['best_bowling'] ?? '0/0',
    );
  }

  Map<String, dynamic> toJson() => {
        'matches': matches,
        'innings': innings,
        'overs': overs,
        'runs': runs,
        'wickets': wickets,
        'average': average,
        'economy': economy,
        'strike_rate': strikeRate,
        'best_bowling': bestBowling,
      };
}

class FieldingStats {
  final int matches;
  final int catches;
  final int stumpings;
  final int runouts;

  FieldingStats({
    required this.matches,
    required this.catches,
    required this.stumpings,
    required this.runouts,
  });

  factory FieldingStats.fromJson(Map<String, dynamic> json) {
    return FieldingStats(
      matches: json['matches'] ?? 0,
      catches: json['catches'] ?? 0,
      stumpings: json['stumpings'] ?? 0,
      runouts: json['runouts'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'matches': matches,
        'catches': catches,
        'stumpings': stumpings,
        'runouts': runouts,
      };
}
