import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/gradient_bubble.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
          ),
          Positioned(
            top: -250,
            right: -200,
            child: GradientBubble(
              size: 500,
              colors: [
                AppColors.pitx_blue.withOpacity(0.60),
                AppColors.pitx_lt_blue.withOpacity(0.0),
              ],
            ),
          ),
          Positioned(
            bottom: -80,
            right: -20,
            child: GradientBubble(
              size: 300,
              colors: [
                AppColors.pitx_blue.withOpacity(0.80),
                AppColors.pitx_lt_blue.withOpacity(0.0),
              ],
            ),
          ),
          Positioned(
            top: 200,
            left: -300,
            child: GradientBubble(
              size: 500,
              colors: [
                AppColors.pitx_red.withOpacity(0.60),
                AppColors.pitx_red.withOpacity(0.0),
              ],
            ),
          ),
          Positioned(
            top: 600,
            right: -150,
            child: GradientBubble(
              size: 300,
              colors: [
                AppColors.pitx_red.withOpacity(0.60),
                AppColors.pitx_red.withOpacity(0.0),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  const Spacer(),
                  Column(
                    children: [
                      Image.asset('assets/images/pitx_logo.png', height: 60),
                      const SizedBox(height: 12),
                      const Text(
                        'Welcome back, friend!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find routes easily with the\nPITX Commuter App',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    //buttons at the bottom
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton(
                        label: 'Login',
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        textColor: Colors.white,
                      ),
                      // const SizedBox(height: 12),
                      // CustomButton(
                      //   label: 'Register',
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, '/register');
                      //   },
                      // ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                          children: [
                            const TextSpan(text: 'No account yet? '),
                            TextSpan(
                              text: 'Register here.',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/register');
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
