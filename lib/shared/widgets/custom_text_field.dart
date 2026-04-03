import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool showSuffixIconOnFocusOnly;
  final EdgeInsetsGeometry suffixIconPadding;
  final BoxConstraints? suffixIconConstraints;
  final String? hintText;
  // final String? labelText;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.showSuffixIconOnFocusOnly = false,
    this.suffixIconPadding = const EdgeInsets.only(right: 16),
    this.suffixIconConstraints,
    this.hintText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowSuffixIcon =
        !widget.showSuffixIconOnFocusOnly || _focusNode.hasFocus;

    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        suffixIconConstraints: widget.suffixIconConstraints,
        suffixIcon: shouldShowSuffixIcon && widget.suffixIcon != null
            ? Padding(
                padding: widget.suffixIconPadding,
                child: widget.suffixIcon,
              )
            : null,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.pitx_blue.withOpacity(0.10),
            width: 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColors.pitx_blue.withOpacity(0.10),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }
}
