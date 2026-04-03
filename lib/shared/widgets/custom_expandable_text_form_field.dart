import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';

class CustomExpandableTextFormField extends StatefulWidget {
  final String labelText;
  final String? placeholder;
  final int minLines;
  final int maxLines;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;

  const CustomExpandableTextFormField({
    super.key,
    required this.labelText,
    this.placeholder,
    this.minLines = 3,
    this.maxLines = 10,
    this.controller,
    this.focusNode,
    this.enabled = true,
  });

  @override
  State<CustomExpandableTextFormField> createState() => _CustomExpandableTextFormFieldState();
}

class _CustomExpandableTextFormFieldState extends State<CustomExpandableTextFormField> {
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      focusNode: _focusNode,
      keyboardType: TextInputType.multiline,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        labelText: widget.labelText,
        alignLabelWithHint: true,
        hintText: widget.placeholder,
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }
}
