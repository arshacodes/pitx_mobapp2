import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/theme/app_theme.dart';

import '../../../shared/widgets/custom_button.dart';
// import '../../../shared/widgets/custom_location_list_item.dart';
import '../../../shared/widgets/custom_list_item.dart';
import '../../../shared/widgets/custom_secondary_button.dart';
// import '../../../shared/widgets/custom_text_form_field.dart';

import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'report_detail_screen.dart';
import 'report_history_screen.dart';
import 'models/report_item_preview.dart';
// import 'package:pitx_mobapp2/shared/widgets/custom_profile_header.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});
  
  static const List<ReportItemsPreview> _reportItems = [
    ReportItemsPreview(Icons.directions_bus_rounded, 'Facilities', 'Terminal cleanliness and safety concerns'),
    ReportItemsPreview(Icons.badge_rounded, 'Terminal Operations', 'Issues with routes or staff behavior'),
    ReportItemsPreview(Icons.bug_report_rounded, 'Commuter App', 'System bugs, feedback, and suggestions'),
    ReportItemsPreview(Icons.build_rounded, 'Other', 'Any other issues or feedback related to PITX'),
  ];

  static final List<ReportHistoryItem> _sampleReportHistory = [
    ReportHistoryItem(
      category: 'Facilities',
      subject: 'Unclean washroom',
      description: 'Toilet floor is wet and smells bad.',
      status: 'Resolved',
      date: DateTime(2026, 3, 27),
    ),
    ReportHistoryItem(
      category: 'Terminal Operations',
      subject: 'Bus delay',
      description: 'Bus 101 arrived 30 minutes late.',
      status: 'Pending',
      date: DateTime(2026, 3, 28),
    ),
    ReportHistoryItem(
      category: 'Commuter App',
      subject: 'Login error',
      description: 'Unable to login using my account credentials.',
      status: 'In Review',
      date: DateTime(2026, 3, 29),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: "Report a Problem",
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              style: IconButton.styleFrom(
                overlayColor: AppColors.pitx_blue.withOpacity(0.10),
              ),
              // TODO: change icon para nag-sshow ng badge pag may updates sa reports
              icon: const Icon(
                Icons.history_rounded,
                color: AppColors.textPrimary,
                size: 32,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportHistoryScreen(reports: _sampleReportHistory),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Where did the problem happen?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 12),
                    for (final item in _reportItems) ...[
                      CustomListItem(
                        // icon: item.icon,
                        icon: item.icon,
                        title: item.name,
                        subtitle: item.subtitle,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReportDetailScreen(item: item),
                          ),
                        ),
                        // onTap: () => _applyPopularLocation(location),
                      ),
                      if(item != _reportItems.last)
                        Divider(
                          height: 1,
                          color: AppColors.pitx_blue.withOpacity(0.10),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      // ),
    );
  }
}