import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomLocationListItem extends StatefulWidget {
  final String locationName;
  final String locationAddress;
  // final String distance;
  final VoidCallback onTap;
  final bool isFavorite;
  final Color? color;
  final Color? borderColor;

  const CustomLocationListItem({
    super.key,
    required this.locationName,
    required this.locationAddress,
    // required this.distance,
    required this.onTap,
    this.isFavorite = false,
    this.color,
    this.borderColor,
  });

  @override
  State<CustomLocationListItem> createState() => _CustomLocationListItemState();
}

class _CustomLocationListItemState extends State<CustomLocationListItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: widget.borderColor ?? Colors.transparent),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        onHighlightChanged: (isPressed) {
          if (_isPressed == isPressed) return;
          setState(() {
            _isPressed = isPressed;
          });
        },
        onTap: widget.onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: _isPressed ? 0.6 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.pitx_blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.locationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.locationAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  widget.isFavorite
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
