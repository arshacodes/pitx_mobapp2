import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomSecondaryButton extends StatelessWidget {
  final String? label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? prefixIcon;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double iconSize;

  const CustomSecondaryButton({
    super.key,
    this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.prefixIcon,
    this.borderColor,
    this.padding,
    this.width,
    this.height,
    this.iconSize = 20,
  }) : assert(
         label != null || prefixIcon != null,
         'Either label or prefixIcon must be provided.',
       );

  bool get _isIconOnly =>
      prefixIcon != null && (label == null || label!.isEmpty);

  @override
  Widget build(BuildContext context) {
    final foreground = textColor ?? AppColors.pitx_blue;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: foreground,
          elevation: 0,
          padding:
              padding ??
              (_isIconOnly
                  ? const EdgeInsets.all(12)
                  : const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? AppColors.pitx_blue.withOpacity(0.10),
              // width: 1.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          overlayColor: AppColors.pitx_blue.withOpacity(0.10),
        ),
        child: _isIconOnly
            ? Icon(prefixIcon, size: iconSize, color: foreground)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(prefixIcon, size: iconSize, color: foreground),
                    if (label != null && label!.isNotEmpty)
                      const SizedBox(width: 8),
                  ],
                  if (label != null && label!.isNotEmpty)
                    Text(
                      label!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
