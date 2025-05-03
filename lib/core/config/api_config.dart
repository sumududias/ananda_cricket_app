import 'package:flutter/foundation.dart';

class ApiConfig {
  // Set this to true when deploying to production
  static const bool useProduction = false;

  // Production URL (update this with your Railway.app URL)
  static const String productionUrl = 'https://your-app.railway.app';

  // Local development URLs
  static const String currentIp = '192.168.1.28';
  static const String localUrl = 'http://$currentIp:8000';

  // Use production or local URL based on environment
  static String get baseUrl => useProduction ? productionUrl : localUrl;
  static String get apiUrl => '$baseUrl/api';
  static String get mediaUrl => baseUrl;

  // Headers for API requests
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Helper method to get full media URL
  static String getFullMediaUrl(String? path) {
    if (path == null) return '';
    if (path.startsWith('http')) return path;
    return '$mediaUrl$path';
  }

  // API Endpoints
  static String get playersEndpoint => '$apiUrl/players/';
  static String get matchesEndpoint => '$apiUrl/matches/';
  static String get teamsEndpoint => '$apiUrl/teams/';
  static String get tournamentsEndpoint => '$apiUrl/tournaments/';
  static String get matchPlayersEndpoint => '$apiUrl/match-players/';
  static String get substitutionsEndpoint => '$apiUrl/substitutions/';
  static String get teamStandingsEndpoint => '$apiUrl/team-standings/';
}
