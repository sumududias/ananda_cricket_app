import '../../data/models/player.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class PlayerService {
  final ApiService _apiService = ApiService();

  Future<List<Player>> getPlayers() async {
    try {
      final response = await _apiService.getList(ApiConfig.playersEndpoint);
      return response.map((json) => Player.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load players: $e');
    }
  }

  Future<Player> getPlayer(int id) async {
    try {
      final response =
          await _apiService.get('${ApiConfig.playersEndpoint}$id/');
      return Player.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load player: $e');
    }
  }

  Future<Player> createPlayer(Player player) async {
    try {
      final response =
          await _apiService.post(ApiConfig.playersEndpoint, player.toJson());
      return Player.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create player: $e');
    }
  }

  Future<Player> updatePlayer(Player player) async {
    try {
      final response = await _apiService.put(
        '${ApiConfig.playersEndpoint}${player.id}/',
        player.toJson(),
      );
      return Player.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update player: $e');
    }
  }

  Future<void> deletePlayer(int id) async {
    try {
      await _apiService.delete('${ApiConfig.playersEndpoint}$id/');
    } catch (e) {
      throw Exception('Failed to delete player: $e');
    }
  }
}
