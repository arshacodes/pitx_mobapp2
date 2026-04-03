import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String? displayName;
  final String? email;
  final String initials;

  const ProfileHeader({
    this.displayName,
    this.email,
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
        // const SizedBox(height: 12),
        if (displayName != null || email != null) ...[
          const SizedBox(height: 12),
          Text(
            displayName!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            email!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}