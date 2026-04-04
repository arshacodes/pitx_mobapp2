import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
import 'package:pitx_mobapp2/controllers/authentication.dart';

import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  late final AuthenticationController _authController;
  String _errorMessage = '';

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool _isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    return usernameRegex.hasMatch(username) && username.length <= 20;
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+63[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthenticationController());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _errorMessage = '');

    // Validation
    if (_nameController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your full name');
      return;
    }
    if (_emailController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email');
      return;
    }
    if (!_isValidEmail(_emailController.text)) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }
    if (_phoneController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your phone number');
      return;
    }
    if (!_isValidPhone(_phoneController.text)) {
      setState(() => _errorMessage = 'Please enter a valid mobile number');
      return;
    }
    if (_usernameController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a username');
      return;
    }
    if (!_isValidUsername(_usernameController.text)) {
      setState(() => _errorMessage = 'Username can only contain letters, numbers, dashes, and underscores (max 20 chars)');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a password');
      return;
    }
    if (_passwordController.text.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters');
      return;
    }
    if (_passwordConfirmController.text.isEmpty) {
      setState(() => _errorMessage = 'Please confirm your password');
      return;
    }
    if (_passwordController.text != _passwordConfirmController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    // Call register
    try {
      await _authController.register(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmController.text,
      );
      // Success - navigate to main screen
      Get.offNamedUntil('/main', (route) => false);
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          style: IconButton.styleFrom(
            overlayColor: AppColors.pitx_blue.withOpacity(0.10),
          ),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 32,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Dismiss keyboard when scrolling starts
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create your account',
                  style: TextStyle(
                    fontSize: 28,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextFormField(
                labelText: 'Full name',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              IntlPhoneField(
                initialCountryCode: 'PH',
                onChanged: (phone) {
                  _phoneController.text = phone.completeNumber;
                },
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: AppColors.pitx_blue.withOpacity(0.10),
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: AppColors.pitx_blue.withOpacity(0.10),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Username',
                controller: _usernameController,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: true,
                suffixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.pitx_blue.withOpacity(0.30),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Confirm Password',
                controller: _passwordConfirmController,
                obscureText: true,
                suffixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.pitx_blue.withOpacity(0.30),
                ),
              ),
              if (_errorMessage.isNotEmpty) const SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.red.withOpacity(0.10)),
                  ),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Obx(() => _authController.isLoading.value
                  ? SizedBox(
                      height: 58,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightTheme.primaryColor,
                          disabledBackgroundColor: AppTheme.lightTheme.primaryColor.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                          // padding: EdgeInsets.all(16),
                        ),
                      ),
                    )
                  : CustomButton(
                      label: 'Create Account',
                      onPressed: _submit,
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      textColor: Colors.white,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
