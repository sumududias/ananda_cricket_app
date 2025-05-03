import '../models/tournament.dart';
import '../../core/services/api_service.dart';
import '../../core/config/api_config.dart';

class TournamentService {
  final ApiService _apiService = ApiService();

  Future<List<Tournament>> getTournaments() async {
    try {
      final response = await _apiService.getList(ApiConfig.tournamentsEndpoint);
      return response.map((json) => Tournament.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load tournaments: $e');
    }
  }

  Future<Tournament> getTournament(int id) async {
    try {
      final response =
          await _apiService.get('${ApiConfig.tournamentsEndpoint}$id/');
      return Tournament.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load tournament: $e');
    }
  }

  Future<Tournament> createTournament(Tournament tournament) async {
    try {
      final response = await _apiService.post(
          ApiConfig.tournamentsEndpoint, tournament.toJson());
      return Tournament.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create tournament: $e');
    }
  }

  Future<Tournament> updateTournament(Tournament tournament) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.tournamentsEndpoint}${tournament.id}/',
        tournament.toJson(),
      );
      return Tournament.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update tournament: $e');
    }
  }

  Future<void> deleteTournament(int id) async {
    try {
      await _apiService.delete('${ApiConfig.tournamentsEndpoint}$id/');
    } catch (e) {
      throw Exception('Failed to delete tournament: $e');
    }
  }

  Future<List<Tournament>> getActiveTournaments() async {
    try {
      final response =
          await _apiService.getList('${ApiConfig.tournamentsEndpoint}active/');
      return response.map((json) => Tournament.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load active tournaments: $e');
    }
  }

  Future<void> updateTournamentStandings(
      int tournamentId, List<Map<String, dynamic>> standings) async {
    try {
      await _apiService.put(
        '${ApiConfig.tournamentsEndpoint}$tournamentId/standings/',
        {'standings': standings},
      );
    } catch (e) {
      throw Exception('Failed to update tournament standings: $e');
    }
  }
}
