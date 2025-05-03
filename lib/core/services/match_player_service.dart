import '../../data/models/match_player.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class MatchPlayerService extends ApiService {
  MatchPlayerService() : super(ApiConfig.matchPlayersEndpoint);

  Future<List<MatchPlayer>> getMatchPlayers() async {
    return getList<MatchPlayer>(MatchPlayer.fromJson);
  }

  Future<List<MatchPlayer>> getMatchPlayersByMatch(int matchId) async {
    try {
      final response = await getList<MatchPlayer>(MatchPlayer.fromJson);
      return response.where((mp) => mp.match == matchId).toList();
    } catch (e) {
      throw Exception('Failed to load match players: $e');
    }
  }

  Future<List<MatchPlayer>> getMatchPlayersByTeam(int teamId) async {
    try {
      final response = await getList<MatchPlayer>(MatchPlayer.fromJson);
      return response.where((mp) => mp.team == teamId).toList();
    } catch (e) {
      throw Exception('Failed to load match players: $e');
    }
  }

  Future<MatchPlayer> getMatchPlayer(int id) async {
    return getById<MatchPlayer>(id, MatchPlayer.fromJson);
  }
}
