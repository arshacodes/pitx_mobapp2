import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:pitx_mobapp2/constants/constants.dart';
import 'package:pitx_mobapp2/controllers/authentication.dart';
import 'package:pitx_mobapp2/core/models/route_favorite.dart';

class AnalyticsService {
  final AuthenticationController _auth = Get.find<AuthenticationController>();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_auth.token.value}',
      };

  void _checkUnauthorized(http.Response response) {
    if (response.statusCode == 401) {
      _auth.logout();
      Get.offAllNamed('/');
      throw Exception('Session expired. Please log in again.');
    }
  }

  // Fire-and-forget — errors are silently logged, never surfaced to the user
  Future<void> logSearch({
    required String origin,
    required String destination,
  }) async {
    try {
      await http.post(
        Uri.parse('$url/analytics/route-searches'),
        headers: _headers,
        body: jsonEncode({'origin': origin, 'destination': destination}),
      );
    } catch (e) {
      debugPrint('logSearch error: $e');
    }
  }

  // GET /analytics/route-favorites
  Future<List<RouteFavorite>> getFavorites() async {
    final response = await http.get(
      Uri.parse('$url/analytics/route-favorites'),
      headers: _headers,
    );

    _checkUnauthorized(response);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'] as List<dynamic>;
      return data
          .map((e) => RouteFavorite.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    debugPrint('getFavorites failed: ${response.statusCode}');
    throw Exception('Failed to load favorites.');
  }

  // POST /analytics/route-favorites — idempotent, returns existing or new record
  Future<RouteFavorite> addFavorite({
    required String origin,
    required String destination,
  }) async {
    final response = await http.post(
      Uri.parse('$url/analytics/route-favorites'),
      headers: _headers,
      body: jsonEncode({'origin': origin, 'destination': destination}),
    );

    _checkUnauthorized(response);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return RouteFavorite.fromJson(body['data'] as Map<String, dynamic>);
    }

    throw Exception('Failed to save favorite.');
  }

  // DELETE /analytics/route-favorites/{id}
  Future<void> removeFavorite(int id) async {
    final response = await http.delete(
      Uri.parse('$url/analytics/route-favorites/$id'),
      headers: _headers,
    );

    _checkUnauthorized(response);

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite.');
    }
  }
}
