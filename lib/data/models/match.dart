class Match {
  final int id;
  final int team;
  final String opponent;
  final DateTime matchDate;
  final String? venue;
  final String? matchType;
  final String? matchFormat;
  final int? tournament;
  final String? tournamentName;
  final String? tossWinner;
  final String? tossDecision;
  final String? result;
  final String? anandaScore;
  final String? opponentScore;
  final int anandaExtrasByes;
  final int anandaExtrasLegByes;
  final int opponentExtrasByes;
  final int opponentExtrasLegByes;
  final String? summary;
  final int? manOfMatch;
  final String? manOfMatchName;
  final String? scorecardPhoto;
  final List<MatchPlayer>? players;

  Match({
    required this.id,
    required this.team,
    required this.opponent,
    required this.matchDate,
    this.venue,
    this.matchType,
    this.matchFormat,
    this.tournament,
    this.tournamentName,
    this.tossWinner,
    this.tossDecision,
    this.result,
    this.anandaScore,
    this.opponentScore,
    this.anandaExtrasByes = 0,
    this.anandaExtrasLegByes = 0,
    this.opponentExtrasByes = 0,
    this.opponentExtrasLegByes = 0,
    this.summary,
    this.manOfMatch,
    this.manOfMatchName,
    this.scorecardPhoto,
    this.players,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] ?? 0,
      team: json['team'] ?? 0,
      opponent: json['opponent'] ?? '',
      matchDate: json['match_date'] != null
          ? DateTime.parse(json['match_date'])
          : DateTime.now(),
      venue: json['venue'],
      matchType: json['match_type'],
      matchFormat: json['match_format'],
      tournament: json['tournament'],
      tournamentName: json['tournament_name'],
      tossWinner: json['toss_winner'],
      tossDecision: json['toss_decision'],
      result: json['result'],
      anandaScore: json['ananda_score'],
      opponentScore: json['opponent_score'],
      anandaExtrasByes: json['ananda_extras_byes'] ?? 0,
      anandaExtrasLegByes: json['ananda_extras_leg_byes'] ?? 0,
      opponentExtrasByes: json['opponent_extras_byes'] ?? 0,
      opponentExtrasLegByes: json['opponent_extras_leg_byes'] ?? 0,
      summary: json['summary'],
      manOfMatch: json['man_of_match'],
      manOfMatchName: json['man_of_match_name'],
      scorecardPhoto: json['scorecard_photo'],
      players: json['players'] != null
          ? List<MatchPlayer>.from(
              json['players'].map((x) => MatchPlayer.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'team': team,
        'opponent': opponent,
        'match_date': matchDate.toIso8601String(),
        'venue': venue,
        'match_type': matchType,
        'match_format': matchFormat,
        'tournament': tournament,
        'tournament_name': tournamentName,
        'toss_winner': tossWinner,
        'toss_decision': tossDecision,
        'result': result,
        'ananda_score': anandaScore,
        'opponent_score': opponentScore,
        'ananda_extras_byes': anandaExtrasByes,
        'ananda_extras_leg_byes': anandaExtrasLegByes,
        'opponent_extras_byes': opponentExtrasByes,
        'opponent_extras_leg_byes': opponentExtrasLegByes,
        'summary': summary,
        'man_of_match': manOfMatch,
        'man_of_match_name': manOfMatchName,
        'scorecard_photo': scorecardPhoto,
        'players': players?.map((x) => x.toJson()).toList(),
      };

  int get anandaTotalExtras {
    int playerExtras = 0;
    if (players != null) {
      for (var player in players!) {
        playerExtras += (player.wides ?? 0) + (player.noBalls ?? 0);
      }
    }
    return anandaExtrasByes + anandaExtrasLegByes + playerExtras;
  }

  int get opponentTotalExtras {
    int playerExtras = 0;
    if (players != null) {
      for (var player in players!) {
        playerExtras += (player.wides ?? 0) + (player.noBalls ?? 0);
      }
    }
    return opponentExtrasByes + opponentExtrasLegByes + playerExtras;
  }

  bool get isTestMatch => matchFormat == 'TEST';
}

class MatchPlayer {
  final int id;
  final int match;
  final int player;
  final String? playerName;
  final int? battingOrder;
  final int runsScored;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final String? howOut;
  final double oversBowled;
  final int runsConceded;
  final int wicketsTaken;
  final int? wides;
  final int? noBalls;
  final int? maidens;
  final int catches;
  final int stumpings;
  final int runouts;
  final bool isPlayingXI;
  final bool isSubstitute;
  final Substitution? substitution;

  MatchPlayer({
    required this.id,
    required this.match,
    required this.player,
    this.playerName,
    this.battingOrder,
    required this.runsScored,
    required this.ballsFaced,
    required this.fours,
    required this.sixes,
    this.howOut,
    required this.oversBowled,
    required this.runsConceded,
    required this.wicketsTaken,
    this.wides = 0,
    this.noBalls = 0,
    this.maidens = 0,
    required this.catches,
    required this.stumpings,
    required this.runouts,
    required this.isPlayingXI,
    required this.isSubstitute,
    this.substitution,
  });

  factory MatchPlayer.fromJson(Map<String, dynamic> json) {
    return MatchPlayer(
      id: json['id'] ?? 0,
      match: json['match'] ?? 0,
      player: json['player'] ?? 0,
      playerName: json['player_name'],
      battingOrder: json['batting_order'],
      runsScored: json['runs_scored'] ?? 0,
      ballsFaced: json['balls_faced'] ?? 0,
      fours: json['fours'] ?? 0,
      sixes: json['sixes'] ?? 0,
      howOut: json['how_out'],
      oversBowled: (json['overs_bowled'] ?? 0).toDouble(),
      runsConceded: json['runs_conceded'] ?? 0,
      wicketsTaken: json['wickets_taken'] ?? 0,
      wides: json['wides'] ?? json['wide_balls'] ?? 0,
      noBalls: json['no_balls'] ?? 0,
      maidens: json['maidens'] ?? 0,
      catches: json['catches'] ?? 0,
      stumpings: json['stumpings'] ?? 0,
      runouts: json['runouts'] ?? 0,
      isPlayingXI: json['is_playing_xi'] ?? true,
      isSubstitute: json['is_substitute'] ?? false,
      substitution: json['substitution'] != null
          ? Substitution.fromJson(json['substitution'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'match': match,
        'player': player,
        'player_name': playerName,
        'batting_order': battingOrder,
        'runs_scored': runsScored,
        'balls_faced': ballsFaced,
        'fours': fours,
        'sixes': sixes,
        'how_out': howOut,
        'overs_bowled': oversBowled,
        'runs_conceded': runsConceded,
        'wickets_taken': wicketsTaken,
        'wides': wides,
        'no_balls': noBalls,
        'maidens': maidens,
        'catches': catches,
        'stumpings': stumpings,
        'runouts': runouts,
        'is_playing_xi': isPlayingXI,
        'is_substitute': isSubstitute,
        'substitution': substitution?.toJson(),
      };

  double get strikeRate =>
      ballsFaced > 0 ? (runsScored * 100) / ballsFaced : 0.0;

  double get bowlingEconomy =>
      oversBowled > 0 ? runsConceded / oversBowled : 0.0;
}

class Substitution {
  final int id;
  final int match;
  final int playerOut;
  final String? playerOutName;
  final int playerIn;
  final String? playerInName;
  final String reason;
  final String? comments;
  final String substitutionTime;
  final String approvedBy;

  Substitution({
    required this.id,
    required this.match,
    required this.playerOut,
    this.playerOutName,
    required this.playerIn,
    this.playerInName,
    required this.reason,
    this.comments,
    required this.substitutionTime,
    required this.approvedBy,
  });

  factory Substitution.fromJson(Map<String, dynamic> json) {
    return Substitution(
      id: json['id'] ?? 0,
      match: json['match'] ?? 0,
      playerOut: json['player_out'] ?? 0,
      playerOutName: json['player_out_name'],
      playerIn: json['player_in'] ?? 0,
      playerInName: json['player_in_name'],
      reason: json['reason'] ?? '',
      comments: json['comments'],
      substitutionTime: json['substitution_time'] ?? '',
      approvedBy: json['approved_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'match': match,
        'player_out': playerOut,
        'player_out_name': playerOutName,
        'player_in': playerIn,
        'player_in_name': playerInName,
        'reason': reason,
        'comments': comments,
        'substitution_time': substitutionTime,
        'approved_by': approvedBy,
      };
}
