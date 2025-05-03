import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  Future<List<dynamic>> getList(String endpoint) async {
    try {
      if (kDebugMode) {
        print('Fetching data from: $endpoint');
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      if (kDebugMode) {
        print('Fetching item from: $endpoint');
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load item: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      throw Exception('Failed to load item: $e');
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print('Posting data to: $endpoint');
        print('Request body: $data');
      }

      final response = await http.post(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
        body: json.encode(data),
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create item: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      throw Exception('Failed to create item: $e');
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      if (kDebugMode) {
        print('Putting data to: $endpoint');
        print('Request body: $data');
      }

      final response = await http.put(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
        body: json.encode(data),
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      if (kDebugMode) {
        print('Deleting item at: $endpoint');
      }

      final response = await http.delete(
        Uri.parse(endpoint),
        headers: ApiConfig.headers,
      );

      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
      }

      if (response.statusCode != 204) {
        throw Exception('Failed to delete item: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('API Error: $e');
      }
      throw Exception('Failed to delete item: $e');
    }
  }
}
