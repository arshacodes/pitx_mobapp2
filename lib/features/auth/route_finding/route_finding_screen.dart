import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/models/route_favorite.dart';
import 'package:pitx_mobapp2/core/services/analytics_service.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';
import 'package:pitx_mobapp2/features/auth/route_finding/route_finding_map_screen.dart';

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
  final _analyticsService = AnalyticsService();

  String? _message;
  bool _hasValidSearch = false; // true when last search had non-empty origin+destination
  List<RouteFavorite> _favorites = [];
  bool _isFavorited = false; // whether current origin+dest is already a favorite

  static const List<_RouteLocationPreview> _popularLocations = [
    _RouteLocationPreview('PITX', 'Paranaque Integrated Terminal Exchange'),
    _RouteLocationPreview('SM Mall of Asia', 'Seaside Blvd, Pasay'),
    _RouteLocationPreview('Ayala Malls Manila Bay', 'Aseana Ave, Paranaque'),
    _RouteLocationPreview('Baclaran', 'EDSA Extension, Pasay'),
  ];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _analyticsService.getFavorites();
      if (mounted) setState(() => _favorites = favorites);
    } catch (e) {
      debugPrint('Failed to load favorites: $e');
    }
  }

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

    if (origin.isNotEmpty && destination.isNotEmpty) {
      // Fire-and-forget — does not block or show errors to the user
      _analyticsService.logSearch(origin: origin, destination: destination);
    }

    setState(() {
      _hasValidSearch = origin.isNotEmpty && destination.isNotEmpty;
      _message = _hasValidSearch
          ? 'Route preview for $origin to $destination will be available soon.'
          : 'Please enter both an origin and a destination.';
      // Check if this pair is already in the loaded favorites
      _isFavorited = _favorites.any(
        (f) => f.origin == origin && f.destination == destination,
      );
    });
  }

  Future<void> _toggleFavorite() async {
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();

    try {
      if (_isFavorited) {
        // Remove: find the matching favorite and delete it
        final existing = _favorites.firstWhere(
          (f) => f.origin == origin && f.destination == destination,
        );
        await _analyticsService.removeFavorite(existing.id);
        if (mounted) {
          setState(() {
            _favorites.removeWhere((f) => f.id == existing.id);
            _isFavorited = false;
          });
        }
      } else {
        // Add: save to backend then update local state
        final saved = await _analyticsService.addFavorite(
          origin: origin,
          destination: destination,
        );
        if (mounted) {
          setState(() {
            _favorites.insert(0, saved);
            _isFavorited = true;
          });
        }
      }
    } catch (e) {
      debugPrint('toggleFavorite error: $e');
    }
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
        if (_favorites.isEmpty) {
          return const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No saved routes yet.\nSearch for a route and tap the star to save it.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _favorites.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = _favorites[index];

              return ListTile(
                title: Text('${item.origin} to ${item.destination}'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.pop(context);
                  // Reuse existing apply logic by setting controllers directly
                  setState(() {
                    _originController.text = item.origin;
                    _destinationController.text = item.destination;
                    _message = null;
                    _hasValidSearch = false;
                    _isFavorited = false;
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openMap(RouteMapField field) async {
    FocusScope.of(context).unfocus();

    final initialLocationName = field == RouteMapField.origin
        ? _originController.text.trim()
        : _destinationController.text.trim();

    final selectedLocation = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => RouteFindingMapScreen(
          field: field,
          initialLocationName: initialLocationName,
        ),
      ),
    );

    if (!mounted || selectedLocation == null || selectedLocation.trim().isEmpty) {
      return;
    }

    setState(() {
      if (field == RouteMapField.origin) {
        _originController.text = selectedLocation;
      } else {
        _destinationController.text = selectedLocation;
      }
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        suffixIcon: IconButton(
                          onPressed: () => _openMap(RouteMapField.origin),
                          icon: Icon(
                            Icons.map_rounded,
                            color: AppColors.pitx_blue.withOpacity(0.45),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          splashRadius: 20,
                          tooltip: 'Pick origin on map',
                        ),
                        showSuffixIconOnFocusOnly: true,
                        suffixIconPadding: const EdgeInsets.only(right: 8),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
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
                        suffixIcon: IconButton(
                          onPressed: () => _openMap(RouteMapField.destination),
                          icon: Icon(
                            Icons.map_rounded,
                            color: AppColors.pitx_blue.withOpacity(0.45),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          visualDensity: VisualDensity.compact,
                          splashRadius: 20,
                          tooltip: 'Pick destination on map',
                        ),
                        showSuffixIconOnFocusOnly: true,
                        suffixIconPadding: const EdgeInsets.only(right: 8),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        overlayColor: AppColors.pitx_blue.withOpacity(0.10),
                        padding: const EdgeInsets.all(12),
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
                    onPressed: () => _openMap(
                      _destinationFocusNode.hasFocus
                          ? RouteMapField.destination
                          : RouteMapField.origin,
                    ),
                  ),
                ),
              ],
            ),
            if (_message != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 12, top: 8, bottom: 8, right: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.pitx_blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _message!,
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                    // Star icon only appears for valid (non-error) searches
                    if (_hasValidSearch)
                      IconButton(
                        icon: Icon(
                          _isFavorited ? Icons.star_rounded : Icons.star_border_rounded,
                          color: _isFavorited
                              ? AppColors.pitx_blue
                              : AppColors.textSecondary,
                        ),
                        tooltip: _isFavorited ? 'Remove from favorites' : 'Save to favorites',
                        onPressed: _toggleFavorite,
                      ),
                  ],
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

