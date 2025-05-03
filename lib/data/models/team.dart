class Team {
  final int id;
  final String name;
  final String season;
  final String coach;
  final int? captain;
  final String? logo;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastModified;
  final TeamStats? stats;

  Team({
    required this.id,
    required this.name,
    required this.season,
    required this.coach,
    this.captain,
    this.logo,
    this.description,
    required this.isActive,
    required this.createdAt,
    this.lastModified,
    this.stats,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      season: json['season'] ?? '',
      coach: json['coach'] ?? '',
      captain: json['captain'],
      logo: json['logo'],
      description: json['description'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      lastModified: json['last_modified'] != null
          ? DateTime.parse(json['last_modified'])
          : null,
      stats: json['stats'] != null ? TeamStats.fromJson(json['stats']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'season': season,
        'coach': coach,
        'captain': captain,
        'logo': logo,
        'description': description,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
        'last_modified': lastModified?.toIso8601String(),
        'stats': stats?.toJson(),
      };
}

class TeamStats {
  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int matchesDrawn;
  final int points;
  final double netRunRate;
  final int? currentPosition;
  final List<TeamStanding>? standings;

  TeamStats({
    required this.matchesPlayed,
    required this.matchesWon,
    required this.matchesLost,
    required this.matchesDrawn,
    required this.points,
    required this.netRunRate,
    this.currentPosition,
    this.standings,
  });

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      matchesPlayed: json['matches_played'] ?? 0,
      matchesWon: json['matches_won'] ?? 0,
      matchesLost: json['matches_lost'] ?? 0,
      matchesDrawn: json['matches_drawn'] ?? 0,
      points: json['points'] ?? 0,
      netRunRate: (json['net_run_rate'] ?? 0).toDouble(),
      currentPosition: json['current_position'],
      standings: json['standings'] != null
          ? List<TeamStanding>.from(
              json['standings'].map((x) => TeamStanding.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'matches_played': matchesPlayed,
        'matches_won': matchesWon,
        'matches_lost': matchesLost,
        'matches_drawn': matchesDrawn,
        'points': points,
        'net_run_rate': netRunRate,
        'current_position': currentPosition,
        'standings': standings?.map((x) => x.toJson()).toList(),
      };

  double get winPercentage =>
      matchesPlayed > 0 ? (matchesWon / matchesPlayed) * 100 : 0.0;
}

class TeamStanding {
  final int id;
  final int tournament;
  final int team;
  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int matchesDrawn;
  final int points;
  final double netRunRate;
  final int position;

  TeamStanding({
    required this.id,
    required this.tournament,
    required this.team,
    required this.matchesPlayed,
    required this.matchesWon,
    required this.matchesLost,
    required this.matchesDrawn,
    required this.points,
    required this.netRunRate,
    required this.position,
  });

  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      id: json['id'] ?? 0,
      tournament: json['tournament'] ?? 0,
      team: json['team'] ?? 0,
      matchesPlayed: json['matches_played'] ?? 0,
      matchesWon: json['matches_won'] ?? 0,
      matchesLost: json['matches_lost'] ?? 0,
      matchesDrawn: json['matches_drawn'] ?? 0,
      points: json['points'] ?? 0,
      netRunRate: (json['net_run_rate'] ?? 0).toDouble(),
      position: json['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tournament': tournament,
        'team': team,
        'matches_played': matchesPlayed,
        'matches_won': matchesWon,
        'matches_lost': matchesLost,
        'matches_drawn': matchesDrawn,
        'points': points,
        'net_run_rate': netRunRate,
        'position': position,
      };

  double get winPercentage =>
      matchesPlayed > 0 ? (matchesWon / matchesPlayed) * 100 : 0.0;
}
