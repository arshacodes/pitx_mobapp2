import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/services/crm_service.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_button.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_text_form_field.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_expandable_text_form_field.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_attachment_picker.dart';
import 'models/report_item_preview.dart';
import 'report_history_screen.dart';

class ReportDetailScreen extends StatefulWidget {
  final ReportItemsPreview item;

  const ReportDetailScreen({
    super.key,
    required this.item,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _crmService = CrmService();

  List<XFile> _attachments = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final subject = _subjectController.text.trim();
    final body = _descriptionController.text.trim();

    if (subject.isEmpty) {
      setState(() => _errorMessage = 'Please enter a subject.');
      return;
    }
    if (body.isEmpty) {
      setState(() => _errorMessage = 'Please describe the problem.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final thread = await _crmService.createThread(
        category: widget.item.apiValue,
        subject: subject,
        body: body,
      );

      if (_attachments.isNotEmpty && thread.firstMessageId != null) {
        for (final file in _attachments) {
          await _crmService.uploadAttachment(
            threadId: thread.id,
            messageId: thread.firstMessageId!,
            file: file,
          );
        }
      }

      if (mounted) {
        // Navigate to history so the user can see their submitted report
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ReportHistoryScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Report a Problem',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.pitx_blue.withOpacity(0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.item.icon,
                    size: 32,
                    color: AppColors.pitx_blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              labelText: 'Subject',
              controller: _subjectController,
            ),
            const SizedBox(height: 12),
            CustomExpandableTextFormField(
              labelText: 'Description',
              placeholder: 'Describe the problem in detail...',
              controller: _descriptionController,
              minLines: 4,
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            CustomAttachmentPicker(
              allowMultiple: true,
              maxCount: 5,
              onAttachmentsChanged: (attachments) {
                _attachments = attachments;
              },
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
            const Spacer(),
            _isLoading
                ? SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pitx_blue,
                        disabledBackgroundColor: AppColors.pitx_blue.withOpacity(0.6),
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
                    label: 'Submit Report',
                    onPressed: _submit,
                    backgroundColor: AppColors.pitx_blue,
                    textColor: Colors.white,
                  ),
          ],
        ),
      ),
    );
  }
}
