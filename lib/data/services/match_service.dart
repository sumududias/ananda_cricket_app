import '../models/match.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';

class MatchService {
  final ApiService _apiService = ApiService();

  Future<List<Match>> getMatches() async {
    try {
      final response = await _apiService.getList(ApiConfig.matchesEndpoint);
      return response.map((json) => Match.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load matches: $e');
    }
  }

  Future<Match> getMatch(int id) async {
    try {
      final response =
          await _apiService.get('${ApiConfig.matchesEndpoint}$id/');
      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load match: $e');
    }
  }

  Future<Match> createMatch(Match match) async {
    try {
      final response =
          await _apiService.post(ApiConfig.matchesEndpoint, match.toJson());
      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create match: $e');
    }
  }

  Future<Match> updateMatch(Match match) async {
    try {
      final response = await _apiService.put(
          '${ApiConfig.matchesEndpoint}${match.id}/', match.toJson());
      return Match.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update match: $e');
    }
  }

  Future<void> deleteMatch(int id) async {
    try {
      await _apiService.delete('${ApiConfig.matchesEndpoint}$id/');
    } catch (e) {
      throw Exception('Failed to delete match: $e');
    }
  }
}
