import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
import 'package:pitx_mobapp2/controllers/authentication.dart';

import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthenticationController _authController;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthenticationController>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _errorMessage = '');

    if (_usernameController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your username');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter your password');
      return;
    }

    try {
      await _authController.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      Get.offAllNamed('/main');
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showPasswordHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password recovery will be available soon.'),
      ),
    );
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
        child: Padding(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              Column(
                children: [
                  Image.asset('assets/images/pitx_logo.png', height: 60),
                  const SizedBox(height: 12),
                  const Text(
                    'Commuter App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    labelText: 'Username',
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
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
                  // const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showPasswordHelp,
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty) const SizedBox(height: 4),
                  if (_errorMessage.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Container(
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
                    ),
                ],
              ),
              const Spacer(),
              Obx(() => _authController.isLoading.value
                  ? SizedBox(
                      height: 58,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightTheme.primaryColor,
                          disabledBackgroundColor:
                              AppTheme.lightTheme.primaryColor.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    )
                  : CustomButton(
                      label: 'Login',
                      onPressed: _submit,
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      textColor: Colors.white,
                    )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
