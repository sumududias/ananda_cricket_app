class MatchPlayer {
  final int id;
  final int match;
  final int player;
  final int team;
  final bool isPlaying;
  final int? runsScored;
  final int? ballsFaced;
  final int? fours;
  final int? sixes;
  final int? oversBowled;
  final int? wicketsTaken;
  final int? runsConceded;
  final int? catches;
  final int? runouts;
  final int? stumpings;

  MatchPlayer({
    required this.id,
    required this.match,
    required this.player,
    required this.team,
    required this.isPlaying,
    this.runsScored,
    this.ballsFaced,
    this.fours,
    this.sixes,
    this.oversBowled,
    this.wicketsTaken,
    this.runsConceded,
    this.catches,
    this.runouts,
    this.stumpings,
  });

  factory MatchPlayer.fromJson(Map<String, dynamic> json) {
    return MatchPlayer(
      id: json['id'],
      match: json['match'],
      player: json['player'],
      team: json['team'],
      isPlaying: json['is_playing'] ?? false,
      runsScored: json['runs_scored'],
      ballsFaced: json['balls_faced'],
      fours: json['fours'],
      sixes: json['sixes'],
      oversBowled: json['overs_bowled'],
      wicketsTaken: json['wickets_taken'],
      runsConceded: json['runs_conceded'],
      catches: json['catches'],
      runouts: json['runouts'],
      stumpings: json['stumpings'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'match': match,
        'player': player,
        'team': team,
        'is_playing': isPlaying,
        'runs_scored': runsScored,
        'balls_faced': ballsFaced,
        'fours': fours,
        'sixes': sixes,
        'overs_bowled': oversBowled,
        'wickets_taken': wicketsTaken,
        'runs_conceded': runsConceded,
        'catches': catches,
        'runouts': runouts,
        'stumpings': stumpings,
      };

  double? get strikeRate {
    if (runsScored != null && ballsFaced != null && ballsFaced! > 0) {
      return (runsScored! * 100) / ballsFaced!;
    }
    return null;
  }

  double? get economy {
    if (oversBowled != null && runsConceded != null && oversBowled! > 0) {
      return runsConceded! / oversBowled!;
    }
    return null;
  }
}
