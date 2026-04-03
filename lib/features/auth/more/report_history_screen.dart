import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/core/models/crm_thread.dart';
import 'package:pitx_mobapp2/core/services/crm_service.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  final _crmService = CrmService();
  late Future<List<CrmThread>> _threadsFuture;

  @override
  void initState() {
    super.initState();
    _threadsFuture = _crmService.getThreads();
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'facilities':
        return Icons.directions_bus_rounded;
      case 'terminal_operations':
        return Icons.badge_rounded;
      case 'commuter_app':
        return Icons.bug_report_rounded;
      case 'other':
      default:
        return Icons.build_rounded;
    }
  }

  String _labelForCategory(String category) {
    switch (category) {
      case 'facilities':
        return 'Facilities';
      case 'terminal_operations':
        return 'Terminal Operations';
      case 'commuter_app':
        return 'Commuter App';
      case 'other':
      default:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Reports History',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: FutureBuilder<List<CrmThread>>(
          future: _threadsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString().replaceFirst('Exception: ', ''),
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final threads = snapshot.data ?? [];

            if (threads.isEmpty) {
              return Center(
                child: Text(
                  'No reports submitted yet.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              itemCount: threads.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final thread = threads[index];
                final status = thread.isClosed ? 'Resolved' : 'Open';

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  leading: Icon(
                    _iconForCategory(thread.category),
                    color: AppColors.pitx_blue,
                  ),
                  title: Text(thread.subject, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(
                    thread.lastMessageAtHuman ?? thread.createdAtHuman ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: Text(
                    status,
                    style: TextStyle(color: thread.isClosed ? Colors.green : Colors.orange),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(_labelForCategory(thread.category)),
                        content: Text(
                          'Subject: ${thread.subject}\n\nStatus: $status\n\nLast activity: ${thread.lastMessageAtHuman ?? thread.createdAtHuman ?? '—'}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

