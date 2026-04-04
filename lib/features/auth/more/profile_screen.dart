import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pitx_mobapp2/controllers/authentication.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_button.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_profile_header.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_text_form_field.dart';

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

  late final AuthenticationController _authController;

  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthenticationController>();
    // Pre-fill fields with current user data
    final user = _authController.user.value;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _usernameController.text = user.username;
      _phoneController.text = user.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Compute initials from a full name (e.g. "Juan Dela Cruz" → "JD")
  String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _errorMessage = '';
      _successMessage = '';
      _isLoading = true;
    });

    try {
      await _authController.updateProfile(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );
      if (mounted) {
        setState(() => _successMessage = 'Profile updated successfully.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Profile',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header updates reactively when updateProfile() refreshes user.value
              Obx(() {
                final u = _authController.user.value;
                return ProfileHeader(
                  initials: u != null ? _initials(u.name) : '?',
                  displayName: u?.name,
                  email: u?.email,
                );
              }),
              const SizedBox(height: 24),
              CustomTextFormField(
                labelText: 'Full name',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              // Email cannot be changed — field is read-only
              CustomTextFormField(
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Phone number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                placeholder: '+639XXXXXXXXX',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                labelText: 'Username',
                controller: _usernameController,
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
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
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ],
              if (_successMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green.withOpacity(0.15)),
                  ),
                  child: Text(
                    _successMessage,
                    style: const TextStyle(color: Colors.green, fontSize: 14),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _isLoading
                  ? SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pitx_blue,
                          disabledBackgroundColor: AppColors.pitx_blue.withOpacity(0.6),
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
                        ),
                      ),
                    )
                  : CustomButton(
                      label: 'Save Changes',
                      onPressed: _saveChanges,
                      backgroundColor: AppColors.pitx_blue,
                      textColor: Colors.white,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
