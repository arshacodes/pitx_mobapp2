import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
// import 'package:pitx_mobapp2/features/auth/route_finding/route_finding_map_screen.dart';

import '../../../shared/widgets/custom_button.dart';
// import '../../../shared/widgets/custom_location_list_item.dart';
import '../../../shared/widgets/custom_secondary_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_profile_header.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _searchController = TextEditingController();

  String? _message;

  @override
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
        title: "Support Center",
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CustomTextField(
                      // labelText: 'Full name',
                      controller: _searchController,
                      hintText: 'Search for support topics',
                      suffixIcon: IconButton(
                          onPressed: () => _searchController.text.trim().isEmpty
                              ? null
                              : setState(() {
                                  _message =
                                      'Search results for "${_searchController.text.trim()}" will be available soon.';
                                }),
                          icon: Icon(
                            Icons.search_rounded,
                            color: AppColors.pitx_blue,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          splashRadius: 20,
                        ),
                        suffixIconPadding: const EdgeInsets.only(right: 8),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                    ),
                    const SizedBox(height: 12),
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
              // CustomButton(
              //   label: 'Save Changes',
              //   onPressed: _saveChanges,
              //   backgroundColor: AppTheme.lightTheme.primaryColor,
              //   textColor: Colors.white,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}