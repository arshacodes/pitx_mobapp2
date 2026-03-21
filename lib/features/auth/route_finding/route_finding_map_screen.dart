import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_button.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_location_list_item.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_secondary_button.dart';

class RouteFindingMapScreen extends StatefulWidget {
  const RouteFindingMapScreen({super.key});

  @override
  State<RouteFindingMapScreen> createState() => _RouteFindingMapScreenState();
}

class _RouteFindingMapScreenState extends State<RouteFindingMapScreen> {
  bool _isCenteredOnCurrentLocation = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: AppColors.pitx_blue.withOpacity(0.10),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _isCenteredOnCurrentLocation
                            ? 'Centered on your current location'
                            : 'Map View Placeholder',
                        key: ValueKey(_isCenteredOnCurrentLocation),
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomSecondaryButton(
                        prefixIcon: Icons.arrow_back_rounded,
                        onPressed: () => Navigator.pop(context),
                        width: 58,
                        height: 58,
                        padding: EdgeInsets.all(12),
                        textColor: AppColors.textPrimary,
                        borderColor: Colors.transparent,
                        backgroundColor: AppColors.background,
                        iconSize: 32,
                      ),
                      CustomSecondaryButton(
                        prefixIcon: Icons.my_location_rounded,
                        onPressed: () {
                          setState(() {
                            _isCenteredOnCurrentLocation = true;
                          });
                        },
                        width: 58,
                        height: 58,
                        padding: EdgeInsets.all(12),
                        textColor: AppColors.pitx_red,
                        borderColor: Colors.transparent,
                        backgroundColor: AppColors.background,
                        iconSize: 32,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const SizedBox(height: 16),
                Text(
                  'Set your origin location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    decoration: TextDecoration.none,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'Slide map to adjust pin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.none,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(width: 12),
                CustomLocationListItem(
                  color: Colors.white,
                  locationName: 'SM Mall of Asia',
                  locationAddress: 'Seaside Blvd, Pasay',
                  borderColor: AppColors.textSecondary,
                  onTap: () {
                    // TODO: open saved route history item
                  },
                ),
                const SizedBox(height: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      label: 'Confirm Origin',
                      onPressed: () {
                        // Implement login logic here
                      },
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                // const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
