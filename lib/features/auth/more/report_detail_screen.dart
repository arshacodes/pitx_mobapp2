import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'models/report_item_preview.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_button.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_text_field.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_text_form_field.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_expandable_text_form_field.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_attachment_picker.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_expandable_text_form_field.dart';

class ReportDetailScreen extends StatelessWidget {
  final ReportItemsPreview item;

  const ReportDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        // title: item.name,
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
                    item.icon,
                    size: 32,
                    color: AppColors.pitx_blue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
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
              // hintText: 'Subject',
            ),
            const SizedBox(height: 12),
            CustomExpandableTextFormField(
              labelText: 'Description',
              placeholder: 'Describe the problem in detail...',
              minLines: 4,
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            // const Text(
            //   'Attachments (optional)',
            //   style: TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // const SizedBox(height: 8),
            CustomAttachmentPicker(
              allowMultiple: true,
              onAttachmentsChanged: (attachments) {
                // handle attachments as needed e.g. stage for upload
              },
            ),
            // const SizedBox(height: 24),
            const Spacer(),
            CustomButton(
              label: 'Submit Report',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Report submitted successfully!'),
                  ),
                );
              },
              backgroundColor: AppColors.pitx_blue,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
