import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
// import 'package:pitx_mobapp2/features/auth/route_finding/route_finding_map_screen.dart';

import '../../../shared/widgets/custom_button.dart';
// import '../../../shared/widgets/custom_location_list_item.dart';
import '../../../shared/widgets/custom_secondary_button.dart';
import '../../../shared/widgets/custom_text_form_field.dart';

import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_profile_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  String? _message;

  @override
  // void dispose() {
  //   _originController.dispose();
  //   _destinationController.dispose();
  //   _originFocusNode.dispose();
  //   _destinationFocusNode.dispose();
  //   super.dispose();
  // }

  // void _findRoute() {
  //   final origin = _originController.text.trim();
  //   final destination = _destinationController.text.trim();

  //   setState(() {
  //     _message = origin.isEmpty || destination.isEmpty
  //         ? 'Please enter both an origin and a destination.'
  //         : 'Route preview for $origin to $destination will be available soon.';
  //   });
  // }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile changes saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
        AppTopBar(
        title: "Profile",
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const ProfileHeader(
                initials: 'CA',
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: 'Full name',
                      controller: _nameController,
                      placeholder: 'Commuter Account',
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      labelText: 'Email',
                      controller: _emailController,
                      placeholder: 'commuter@example.com',
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      labelText: 'Phone number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      placeholder: '+1 234 567 8900',
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      labelText: 'Username',
                      controller: _usernameController,
                      placeholder: 'commuter_username',
                    ),
                  ],
                ),
              ),
              if (_message != null) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.pitx_blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _message!,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ],
              CustomButton(
                label: 'Save Changes',
                onPressed: _saveChanges,
                backgroundColor: AppTheme.lightTheme.primaryColor,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}