import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/api_config.dart';
import '../models/player.dart';

class ApiService {
  final http.Client _client = http.Client();

  Future<List<dynamic>> getList(String endpoint) async {
    try {
      print('DEBUG: Fetching list from $endpoint');
      final response = await _client.get(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
      );

      print('DEBUG: Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG: Got ${data.length} items');
        return data;
      } else {
        print('DEBUG: Error response: ${response.body}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Error in getList: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      print('DEBUG: Fetching item from $endpoint');
      final response = await _client.get(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
      );

      print('DEBUG: Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('DEBUG: Got response data');
        return data;
      } else {
        print('DEBUG: Error response: ${response.body}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Error in get: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      print('DEBUG: Posting to $endpoint');
      print('DEBUG: Data: $data');
      final response = await _client.post(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
        body: json.encode(data),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('DEBUG: Got response data');
        return responseData;
      } else {
        print('DEBUG: Error response: ${response.body}');
        throw Exception('Failed to create data: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Error in post: $e');
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      print('DEBUG: Putting to $endpoint');
      print('DEBUG: Data: $data');
      final response = await _client.put(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
        body: json.encode(data),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('DEBUG: Got response data');
        return responseData;
      } else {
        print('DEBUG: Error response: ${response.body}');
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Error in put: $e');
      throw Exception('Error: $e');
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      print('DEBUG: Deleting from $endpoint');
      final response = await _client.delete(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
      );

      print('DEBUG: Response status: ${response.statusCode}');
      if (response.statusCode != 204) {
        print('DEBUG: Error response: ${response.body}');
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Error in delete: $e');
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> getPlayers() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.apiUrl}/players/'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Player> fetchPlayerDetails(int playerId) async {
    try {
      final url = Uri.parse('${ApiConfig.apiUrl}/players/$playerId/');
      print('Fetching player details from: $url');

      final response = await _client.get(
        url,
        headers: ApiConfig.headers,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Player.fromJson(_fixImageUrls(json));
      } else {
        throw Exception(
            'Failed to load player details (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error fetching player details: $e');
      throw Exception('Failed to fetch player details: $e');
    }
  }

  Future<List<Player>> fetchPlayers() async {
    try {
      final url = Uri.parse('${ApiConfig.apiUrl}/players/');
      print('DEBUG: Fetching players from: $url');

      final response = await _client.get(
        url,
        headers: ApiConfig.headers,
      );

      print('DEBUG: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('DEBUG: Raw player data: $data');

        final players = data.map((json) {
          print(
              'DEBUG: Processing player: ${json['first_name']} ${json['last_name']}');
          print('DEBUG: Raw photo URL: ${json['photo']}');
          final player = Player.fromJson(_fixImageUrls(json));
          print('DEBUG: Processed photo URL: ${player.photo}');
          return player;
        }).toList();

        return players;
      } else {
        throw Exception(
            'Failed to load players (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('DEBUG: Error fetching players: $e');
      throw Exception('Failed to fetch players: $e');
    }
  }

  // Helper to fix image URLs when switching networks
  static Map<String, dynamic> _fixImageUrls(Map<String, dynamic> json) {
    if (json['photo'] != null && json['photo'] is String) {
      final photo = json['photo'] as String;
      if (!photo.startsWith('http')) {
        // If it's a relative URL, make it absolute
        json['photo'] = 'http://${ApiConfig.currentIp}:8000$photo';
      }
    }
    return json;
  }
}
