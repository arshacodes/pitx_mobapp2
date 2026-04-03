import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';

class ReportHistoryScreen extends StatelessWidget {
  final List<ReportHistoryItem> reports;

  const ReportHistoryScreen({
    super.key,
    this.reports = const [],
  });

  @override
  Widget build(BuildContext context) {
    IconData _iconForCategory(String category) {
      switch (category) {
        case 'Facilities':
          return Icons.directions_bus_rounded;
        case 'Terminal Operations':
          return Icons.badge_rounded;
        case 'Commuter App':
          return Icons.bug_report_rounded;
        case 'Other':
          return Icons.build_rounded;
        default:
          return Icons.report_gmailerrorred_rounded;
      }
    }
    return Scaffold(
      appBar: AppTopBar(
        title: 'Reports History',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: reports.isEmpty
            ? Center(
                child: Text(
                  'No reports submitted yet.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              )
            : ListView.separated(
                itemCount: reports.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    // tileColor: AppColors.pitx_blue.withOpacity(0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    leading: Icon(
                      _iconForCategory(report.category),
                      color: AppColors.pitx_blue,
                    ),
                    title: Text(report.subject, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(report.description, overflow: TextOverflow.ellipsis, maxLines: 1),
                    trailing: Text(report.status, style: TextStyle(color: report.status == 'Resolved' ? Colors.green : Colors.orange)),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(report.category),
                          content: Text('Subject: ${report.subject}\n\nDetails: ${report.description}'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class ReportHistoryItem {
  final String category;
  final String subject;
  final String description;
  final String status;
  final DateTime date;

  ReportHistoryItem({
    required this.category,
    required this.subject,
    required this.description,
    this.status = 'Pending',
    DateTime? date,
  }) : date = date ?? DateTime.now();
}
