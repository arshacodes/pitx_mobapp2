import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_button.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_list_item.dart';
import 'package:pitx_mobapp2/shared/widgets/gradient_bubble.dart';

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
                        const Spacer(),
                        const _ProfileHeader(
                          displayName: 'Commuter Account',
                          email: 'Manage your travel tools and preferences',
                          initials: 'CA',
                        ),
                        const SizedBox(height: 24),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomListItem(
                              icon: Icons.badge_rounded,
                              title: 'Profile',
                              subtitle: 'View your commuter details',
                              onTap: () => _showPlaceholder(
                                context,
                                'Profile tools coming soon.',
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: AppColors.pitx_blue.withOpacity(0.10),
                            ),
                            CustomListItem(
                              icon: Icons.bookmark_rounded,
                              title: 'Saved Routes',
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
                              title: 'Help & Support',
                              subtitle:
                                  'Get commuter assistance and terminal info',
                              onTap: () => _showPlaceholder(
                                context,
                                'Support tools coming soon.',
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

class _ProfileHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String initials;

  const _ProfileHeader({
    required this.displayName,
    required this.email,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.pitx_blue.withOpacity(0.10),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.pitx_blue.withOpacity(0.18)),
          ),
          child: Center(
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.pitx_blue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
