class TeamStanding {
  final int id;
  final int tournament;
  final int team;
  final int matchesPlayed;
  final int won;
  final int lost;
  final int tied;
  final int points;
  final double netRunRate;
  final int position;

  TeamStanding({
    required this.id,
    required this.tournament,
    required this.team,
    required this.matchesPlayed,
    required this.won,
    required this.lost,
    required this.tied,
    required this.points,
    required this.netRunRate,
    required this.position,
  });

  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      id: json['id'],
      tournament: json['tournament'],
      team: json['team'],
      matchesPlayed: json['matches_played'],
      won: json['won'],
      lost: json['lost'],
      tied: json['tied'],
      points: json['points'],
      netRunRate: json['net_run_rate']?.toDouble() ?? 0.0,
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tournament': tournament,
        'team': team,
        'matches_played': matchesPlayed,
        'won': won,
        'lost': lost,
        'tied': tied,
        'points': points,
        'net_run_rate': netRunRate,
        'position': position,
      };

  String get stats => '$won-$lost-$tied';

  double get winPercentage {
    if (matchesPlayed == 0) return 0.0;
    return (won / matchesPlayed) * 100;
  }
}
