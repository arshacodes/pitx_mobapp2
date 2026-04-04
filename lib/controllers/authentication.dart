import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pitx_mobapp2/constants/constants.dart';
import 'package:pitx_mobapp2/core/models/user.dart';

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final user = Rx<User?>(null);
  final token = RxString('');

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('auth_token');
      final savedUser = prefs.getString('auth_user');

      if (savedToken != null && savedUser != null) {
        token.value = savedToken;
        user.value = User.fromJson(jsonDecode(savedUser));
        debugPrint('Session restored');
      }
    } catch (e) {
      debugPrint('Error restoring session: $e');
    }
  }
 
  Future<void> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String username,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      isLoading.value = true;

      var data = jsonEncode({
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'username': username,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      // var response = await http.post(
      //   Uri.parse('$url/auth/register'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: data,
      // );

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        debugPrint('Registration successful: $responseData');

        try {
          // Extract token and user from response
          final data = responseData['data'] as Map<String, dynamic>;
          final tokenFromResponse = data['token'] as String;
          final userData = data['user'] as Map<String, dynamic>;

          // Save to shared preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', tokenFromResponse);
          await prefs.setString('auth_user', jsonEncode(userData));

          // Update controller state
          token.value = tokenFromResponse;
          user.value = User.fromJson(userData);

          debugPrint('Token and user saved successfully');
        } catch (e) {
          debugPrint('Error parsing registration response: $e');
          throw Exception('Failed to process registration response');
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = 'Registration failed';
        
        if (errorResponse['errors'] != null) {
          final errors = errorResponse['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first as List;
          errorMessage = firstError.first.toString();
        } else if (errorResponse['message'] != null) {
          errorMessage = errorResponse['message'];
        }
        
        debugPrint('Registration failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // // final response = await http.post(
      // //   Uri.parse('$url/auth/login'),
      // //   headers: {'Content-Type': 'application/json'},
      // //   body: jsonEncode({'username': username, 'password': password}),
      // // );

      // final response = await http.post(
      //   Uri.parse('${AppConfig.baseUrl}/auth/login'),

      // final fullUrl = '${url.replaceAll(RegExp(r'/$'), '')}/auth/login';

      debugPrint('LOGIN URL: ${AppConfig.baseUrl}/auth/login');

      final body = jsonEncode({
        'username': username,
        'password': password,
      });

      debugPrint('LOGIN PAYLOAD: $body');

      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        try {
          final data = responseData['data'] as Map<String, dynamic>;
          final tokenFromResponse = data['token'] as String;
          final userData = data['user'] as Map<String, dynamic>;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', tokenFromResponse);
          await prefs.setString('auth_user', jsonEncode(userData));

          token.value = tokenFromResponse;
          user.value = User.fromJson(userData);

          debugPrint('Login successful');
        } catch (e) {
          debugPrint('Error parsing login response: $e');
          throw Exception('Failed to process login response');
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = 'Login failed';

        if (errorResponse['errors'] != null) {
          final errors = errorResponse['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first as List;
          errorMessage = firstError.first.toString();
        } else if (errorResponse['message'] != null) {
          errorMessage = errorResponse['message'];
        }

        debugPrint('Login failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // PATCH /auth/me — updates name, username, phone_number (email is not editable)
  Future<void> updateProfile({
    String? name,
    String? username,
    String? phoneNumber,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (username != null) body['username'] = username;
    if (phoneNumber != null) body['phone_number'] = phoneNumber.isEmpty ? null : phoneNumber;

    final response = await http.patch(
      Uri.parse('${AppConfig.baseUrl}/auth/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.value}',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      await logout();
      Get.offAllNamed('/');
      throw Exception('Session expired. Please log in again.');
    }

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final userData = responseData['data'] as Map<String, dynamic>;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_user', jsonEncode(userData));
      user.value = User.fromJson(userData);
    } else {
      final errorResponse = jsonDecode(response.body);
      String errorMessage = 'Update failed';

      if (errorResponse['errors'] != null) {
        final errors = errorResponse['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first as List;
        errorMessage = firstError.first.toString();
      } else if (errorResponse['message'] != null) {
        errorMessage = errorResponse['message'];
      }

      throw Exception(errorMessage);
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('auth_user');

      token.value = '';
      user.value = null;

      debugPrint('Logged out successfully');
    } catch (e) {
      debugPrint('Error during logout: $e');
      rethrow;
    }
  }
}
