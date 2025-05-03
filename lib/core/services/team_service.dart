import '../../data/models/team.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class TeamService {
  final ApiService _apiService = ApiService();

  Future<List<Team>> getTeams() async {
    try {
      final response = await _apiService.getList(ApiConfig.teamsEndpoint);
      return response.map((json) => Team.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load teams: $e');
    }
  }

  Future<Team> getTeam(int id) async {
    try {
      final response = await _apiService.get('${ApiConfig.teamsEndpoint}$id/');
      return Team.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load team: $e');
    }
  }

  Future<Team> createTeam(Team team) async {
    try {
      final response =
          await _apiService.post(ApiConfig.teamsEndpoint, team.toJson());
      return Team.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create team: $e');
    }
  }

  Future<Team> updateTeam(Team team) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.teamsEndpoint}${team.id}/',
        team.toJson(),
      );
      return Team.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update team: $e');
    }
  }

  Future<void> deleteTeam(int id) async {
    try {
      await _apiService.delete('${ApiConfig.teamsEndpoint}$id/');
    } catch (e) {
      throw Exception('Failed to delete team: $e');
    }
  }
}
