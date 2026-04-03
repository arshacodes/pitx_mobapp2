import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/features/auth/more/profile_screen.dart';
import 'package:pitx_mobapp2/features/auth/more/support_screen.dart';
import 'package:pitx_mobapp2/features/auth/more/report_screen.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_button.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_list_item.dart';
import 'package:pitx_mobapp2/shared/widgets/gradient_bubble.dart';

import 'package:pitx_mobapp2/shared/widgets/custom_profile_header.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  void _showPlaceholder(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
        ),
        Positioned(
          bottom: 0,
          right: -300,
          child: GradientBubble(
            size: 500,
            colors: [
              AppColors.pitx_blue.withOpacity(0.60),
              AppColors.pitx_lt_blue.withOpacity(0.0),
            ],
          ),
        ),
        Positioned(
          bottom: -150,
          left: -300,
          child: GradientBubble(
            size: 500,
            colors: [
              AppColors.pitx_red.withOpacity(0.40),
              AppColors.pitx_red.withOpacity(0.0),
            ],
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // const Spacer(),
                        const ProfileHeader(
                          displayName: 'Commuter Account',
                          email: 'Manage your travel tools and preferences',
                          initials: 'CA',
                        ),
                        const SizedBox(height: 24),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomListItem(
                              icon: Icons.person_rounded,
                              title: 'Profile',
                              subtitle: 'View your commuter details',
                              // onTap: () => _showPlaceholder(
                              //   context,
                              //   'Profile tools coming soon.',
                              // ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfileScreen(),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.pitx_blue.withOpacity(0.10),
                            ),
                            CustomListItem(
                              icon: Icons.star_rounded,
                              title: 'Favorite Routes',
                              subtitle: 'Keep frequent trips close by',
                              onTap: () => _showPlaceholder(
                                context,
                                'Saved routes will appear here soon.',
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.pitx_blue.withOpacity(0.10),
                            ),
                            CustomListItem(
                              icon: Icons.contact_support_rounded,
                              title: 'Support Center',
                              subtitle:
                                  'Get commuter assistance and terminal info',
                              // onTap: () => _showPlaceholder(
                              //   context,
                              //   'Support tools coming soon.',
                              // ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SupportScreen(),
                                ),
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.pitx_blue.withOpacity(0.10),
                            ),
                            CustomListItem(
                              icon: Icons.report_problem_rounded,
                              title: 'Report a Problem',
                              subtitle:
                                  'Help us improve by reporting issues or feedback',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ReportScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          label: 'Log Out',
                          onPressed: () => _logout(context),
                          backgroundColor: AppColors.pitx_red,
                          textColor: Colors.white,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}