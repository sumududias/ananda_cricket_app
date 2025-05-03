import 'package:intl/intl.dart';
import 'team.dart';

class Tournament {
  final int id;
  final String name;
  final String season;
  final DateTime startDate;
  final DateTime endDate;
  final String organizer;
  final int? winnerTeam;
  final List<TeamStanding>? standings;

  Tournament({
    required this.id,
    required this.name,
    required this.season,
    required this.startDate,
    required this.endDate,
    required this.organizer,
    this.winnerTeam,
    this.standings,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      season: json['season'] ?? '',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : DateTime.now(),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : DateTime.now(),
      organizer: json['organizer'] ?? '',
      winnerTeam: json['winner_team'],
      standings: json['standings'] != null
          ? List<TeamStanding>.from(
              json['standings'].map((x) => TeamStanding.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'season': season,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'organizer': organizer,
        'winner_team': winnerTeam,
        'standings': standings?.map((x) => x.toJson()).toList(),
      };

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isUpcoming => DateTime.now().isBefore(startDate);

  bool get isCompleted => DateTime.now().isAfter(endDate);

  String get dateRange => '${_formatDate(startDate)} - ${_formatDate(endDate)}';

  String get status {
    if (isCompleted) return 'Completed';
    if (isActive) return 'In Progress';
    return 'Upcoming';
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
