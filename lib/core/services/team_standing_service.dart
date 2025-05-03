import '../../data/models/team_standing.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class TeamStandingService extends ApiService {
  TeamStandingService() : super(ApiConfig.teamStandingsEndpoint);

  Future<List<TeamStanding>> getTeamStandings() async {
    return getList<TeamStanding>(TeamStanding.fromJson);
  }

  Future<List<TeamStanding>> getTeamStandingsByTournament(
      int tournamentId) async {
    try {
      final response = await getList<TeamStanding>(TeamStanding.fromJson);
      return response.where((ts) => ts.tournament == tournamentId).toList()
        ..sort((a, b) => a.position.compareTo(b.position));
    } catch (e) {
      throw Exception('Failed to load team standings: $e');
    }
  }

  Future<TeamStanding> getTeamStanding(int id) async {
    return getById<TeamStanding>(id, TeamStanding.fromJson);
  }
}
