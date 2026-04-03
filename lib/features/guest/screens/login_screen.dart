import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';

import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  void _submit() {
    // Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
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
                    labelText: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                ],
              ),
              const Spacer(),
              CustomButton(
                label: 'Login',
                onPressed: _submit,
                backgroundColor: AppTheme.lightTheme.primaryColor,
                textColor: Colors.white,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
