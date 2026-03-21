import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';

import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_location_list_item.dart';
import '../../../shared/widgets/custom_secondary_button.dart';
import '../../../shared/widgets/custom_text_form_field.dart';

class RouteFindingScreen extends StatefulWidget {
  const RouteFindingScreen({super.key});

  @override
  State<RouteFindingScreen> createState() => _RouteFindingScreenState();
}

class _RouteFindingScreenState extends State<RouteFindingScreen> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _originFocusNode = FocusNode();
  final _destinationFocusNode = FocusNode();

  String? _message;

  static const List<_RouteLocationPreview> _popularLocations = [
    _RouteLocationPreview('PITX', 'Paranaque Integrated Terminal Exchange'),
    _RouteLocationPreview('SM Mall of Asia', 'Seaside Blvd, Pasay'),
    _RouteLocationPreview('Ayala Malls Manila Bay', 'Aseana Ave, Paranaque'),
    _RouteLocationPreview('Baclaran', 'EDSA Extension, Pasay'),
  ];

  static const List<_RecentRoutePreview> _recentRoutes = [
    _RecentRoutePreview('PITX', 'SM Mall of Asia'),
    _RecentRoutePreview('Baclaran', 'PITX'),
    _RecentRoutePreview('Ayala Malls Manila Bay', 'PITX'),
  ];

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _originFocusNode.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  void _findRoute() {
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();

    setState(() {
      _message = origin.isEmpty || destination.isEmpty
          ? 'Please enter both an origin and a destination.'
          : 'Route preview for $origin to $destination will be available soon.';
    });
  }

  void _applyPopularLocation(_RouteLocationPreview location) {
    final fillOrigin =
        _originFocusNode.hasFocus ||
        (!_destinationFocusNode.hasFocus &&
            _originController.text.trim().isEmpty);

    setState(() {
      if (fillOrigin) {
        _originController.text = location.name;
      } else {
        _destinationController.text = location.name;
      }
      _message = null;
    });
  }

  void _applyHistoryItem(_RecentRoutePreview item) {
    setState(() {
      _originController.text = item.origin;
      _destinationController.text = item.destination;
      _message = null;
    });
  }

  void _swapLocations() {
    final origin = _originController.text;

    setState(() {
      _originController.text = _destinationController.text;
      _destinationController.text = origin;
      _message = null;
    });
  }

  Future<void> _showHistorySheet() async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _recentRoutes.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = _recentRoutes[index];

              return ListTile(
                title: Text('${item.origin} to ${item.destination}'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(context);
                  _applyHistoryItem(item);
                },
              );
            },
          ),
        );
      },
    );
  }

  void _openMap() {
    Navigator.pushNamed(context, '/route-finding-map');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelText: 'Origin',
                        controller: _originController,
                        focusNode: _originFocusNode,
                        prefixIcon: const Icon(
                          Icons.trip_origin_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      CustomTextFormField(
                        labelText: 'Destination',
                        controller: _destinationController,
                        focusNode: _destinationFocusNode,
                        prefixIcon: const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.pitx_red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    overlayColor: AppColors.pitx_blue.withOpacity(0.10),
                    padding: const EdgeInsets.all(14),
                  ),
                  icon: const Icon(
                    Icons.swap_vert_rounded,
                    color: AppColors.pitx_blue,
                    size: 28,
                  ),
                  onPressed: _swapLocations,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomSecondaryButton(
                    label: 'History',
                    prefixIcon: Icons.access_time_filled_rounded,
                    onPressed: _showHistorySheet,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomSecondaryButton(
                    label: 'Open Map',
                    prefixIcon: Icons.map_rounded,
                    onPressed: _openMap,
                  ),
                ),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.pitx_blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _message!,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Popular Stops',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final location in _popularLocations) ...[
                    CustomLocationListItem(
                      color: Colors.white,
                      locationName: location.name,
                      locationAddress: location.address,
                      borderColor: AppColors.pitx_blue.withOpacity(0.10),
                      onTap: () => _applyPopularLocation(location),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Find Route',
              onPressed: _findRoute,
              backgroundColor: AppTheme.lightTheme.primaryColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteLocationPreview {
  final String name;
  final String address;

  const _RouteLocationPreview(this.name, this.address);
}

class _RecentRoutePreview {
  final String origin;
  final String destination;

  const _RecentRoutePreview(this.origin, this.destination);
}
