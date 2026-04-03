import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';

class CustomAttachmentPicker extends StatefulWidget {
  final List<PlatformFile>? initialAttachments;
  final bool allowMultiple;
  final String buttonLabel;
  final void Function(List<PlatformFile>)? onAttachmentsChanged;

  const CustomAttachmentPicker({
    super.key,
    this.initialAttachments,
    this.allowMultiple = true,
    this.buttonLabel = 'Add Images (optional)',
    this.onAttachmentsChanged,
  });

  @override
  State<CustomAttachmentPicker> createState() => _CustomAttachmentPickerState();
}

class _CustomAttachmentPickerState extends State<CustomAttachmentPicker> {
  late List<PlatformFile> _attachments;

  @override
  void initState() {
    super.initState();
    _attachments = List.from(widget.initialAttachments ?? []);
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.allowMultiple,
      withReadStream: true,
      withData: false,
    );

    if (result == null) return;

    setState(() {
      final newFiles = result.files
          .where((file) => !_attachments.any((existing) => existing.path == file.path))
          .toList();
      _attachments.addAll(newFiles);
    });

    widget.onAttachmentsChanged?.call(_attachments);
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
    widget.onAttachmentsChanged?.call(_attachments);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          // width: double.infinity,
          child: OutlinedButton(
            onPressed: _pickFiles,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.pitx_blue,
              side: BorderSide(color: AppColors.pitx_blue.withOpacity(0.45)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.all(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.attachment_rounded, size: 24),
                const SizedBox(width: 16),
                Text(widget.buttonLabel, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Max size: 10MB',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        if (_attachments.isNotEmpty) ...[
          // const SizedBox(height: 2),
          ..._attachments.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;

            return Column(
              children: [
                Container(
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                    leading: const Icon(Icons.image_rounded, color: AppColors.pitx_blue, size: 24),
                    title: Text(file.name, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                    subtitle: Text('${(file.size / 1024).toStringAsFixed(1)} KB', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: IconButton(
                      icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
                      onPressed: () => _removeAttachment(index),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
                if (index != _attachments.length - 1)
                  const Divider(height: 1, thickness: 1),
              ],
            );
          }),
        ],
      ],
    );
  }
}
