import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:pitx_mobapp2/constants/constants.dart';
import 'package:pitx_mobapp2/controllers/authentication.dart';
import 'package:pitx_mobapp2/core/models/crm_thread.dart';
import 'package:pitx_mobapp2/core/models/crm_message.dart';

class CrmService {
  final AuthenticationController _auth = Get.find<AuthenticationController>();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_auth.token.value}',
      };

  /// GET /crm/threads
  Future<List<CrmThread>> getThreads() async {
    final response = await http.get(
      Uri.parse('$url/crm/threads'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'] as List<dynamic>;
      return data
          .map((e) => CrmThread.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    debugPrint('getThreads failed: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load report history.');
  }

  /// POST /crm/threads
  Future<CrmThread> createThread({
    required String category,
    required String subject,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$url/crm/threads'),
      headers: _headers,
      body: jsonEncode({
        'category': category,
        'subject': subject,
        'body': body,
      }),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return CrmThread.fromJson(responseBody['data'] as Map<String, dynamic>);
    }

    final errorBody = jsonDecode(response.body);
    String errorMessage = 'Failed to submit report.';
    if (errorBody['errors'] != null) {
      final errors = errorBody['errors'] as Map<String, dynamic>;
      errorMessage = (errors.values.first as List).first.toString();
    } else if (errorBody['message'] != null) {
      errorMessage = errorBody['message'] as String;
    }

    throw Exception(errorMessage);
  }

  /// GET /crm/threads/{thread}/messages
  Future<List<CrmMessage>> getMessages(int threadId) async {
    final response = await http.get(
      Uri.parse('$url/crm/threads/$threadId/messages'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data'] as List<dynamic>;
      return data
          .map((e) => CrmMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    debugPrint('getMessages failed: ${response.statusCode} ${response.body}');
    throw Exception('Failed to load messages.');
  }

  /// POST /crm/threads/{thread}/messages
  Future<CrmMessage> sendMessage({
    required int threadId,
    required String body,
  }) async {
    final response = await http.post(
      Uri.parse('$url/crm/threads/$threadId/messages'),
      headers: _headers,
      body: jsonEncode({'body': body}),
    );

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return CrmMessage.fromJson(responseBody['data'] as Map<String, dynamic>);
    }

    throw Exception('Failed to send message.');
  }

  /// POST /crm/threads/{thread}/messages/{message}/attachments
  Future<CrmMessageAttachment> uploadAttachment({
    required int threadId,
    required int messageId,
    required XFile file,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$url/crm/threads/$threadId/messages/$messageId/attachments'),
    );

    request.headers['Authorization'] = 'Bearer ${_auth.token.value}';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return CrmMessageAttachment.fromJson(
          responseBody['data'] as Map<String, dynamic>);
    }

    debugPrint('uploadAttachment failed: ${response.statusCode} ${response.body}');
    throw Exception('Failed to upload attachment.');
  }
}
