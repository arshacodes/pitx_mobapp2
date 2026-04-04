import 'package:flutter/material.dart';

import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_text_field.dart';

// ── Static FAQ data ─────────────────────────────────────────────────────────
// Structured for future API integration: replace _kFaqCategories with a
// service call to GET /api/v1/faq/categories when the backend is ready.

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}

class _FaqCategory {
  final String title;
  final IconData icon;
  final List<_FaqItem> items;
  const _FaqCategory(this.title, this.icon, this.items);
}

const _kFaqCategories = [
  _FaqCategory(
    'Getting Started',
    Icons.play_circle_outline_rounded,
    [
      _FaqItem(
        'How do I create an account?',
        'Tap "Register" on the welcome screen and fill in your name, email, phone number, username, and password. You will be logged in automatically after registration.',
      ),
      _FaqItem(
        'How do I log in?',
        'Enter your username and password on the login screen. If you forget your password, tap "Forgot password?" to get help.',
      ),
    ],
  ),
  _FaqCategory(
    'Route Finding',
    Icons.directions_bus_rounded,
    [
      _FaqItem(
        'How do I find a route?',
        'Go to the Route Finding tab, enter an origin and destination, then tap "Find Route". You can also pick locations from the map using the map icon in each field.',
      ),
      _FaqItem(
        'Can I save a route?',
        'Yes. After searching for a route, tap the star icon next to the result to save it as a favorite. Access saved routes using the "History" button.',
      ),
      _FaqItem(
        'What are Popular Stops?',
        'Popular Stops are frequently visited locations near PITX. Tap any of them to auto-fill your origin or destination field.',
      ),
    ],
  ),
  _FaqCategory(
    'Reports & Issues',
    Icons.report_problem_rounded,
    [
      _FaqItem(
        'How do I report a problem?',
        'Go to More → Report a Problem. Choose a category (Facilities, Terminal Operations, Commuter App, or Other), fill in the subject and description, and optionally attach up to 5 images.',
      ),
      _FaqItem(
        'How do I check the status of my report?',
        'Go to More → Report a Problem → View Report History. Each report shows its status: Open, Ongoing (staff replied), or Resolved.',
      ),
      _FaqItem(
        'Can I reply to a staff message in my report thread?',
        'Yes. Open any report from your history to see the full conversation. As long as the report is not resolved, you can send follow-up messages and attachments.',
      ),
    ],
  ),
  _FaqCategory(
    'Account & Profile',
    Icons.person_rounded,
    [
      _FaqItem(
        'How do I update my profile?',
        'Go to More → Profile. You can edit your name, phone number, and username. Email cannot be changed after registration.',
      ),
      _FaqItem(
        'How do I log out?',
        'Go to the More tab and tap "Log Out" at the bottom of the screen.',
      ),
    ],
  ),
  _FaqCategory(
    'Terminal Info',
    Icons.info_outline_rounded,
    [
      _FaqItem(
        'What is PITX?',
        'PITX (Parañaque Integrated Terminal Exchange) is an integrated bus terminal in Parañaque City, Metro Manila. It serves as a central hub connecting various bus routes across the region.',
      ),
      _FaqItem(
        'What are the operating hours of PITX?',
        'PITX operates 24 hours a day, 7 days a week. Individual bus routes and operators may have different schedules — check with your operator for specific departure times.',
      ),
    ],
  ),
];

// ── Screen ───────────────────────────────────────────────────────────────────

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Returns categories that have at least one item matching the query.
  // If query is empty, returns everything.
  List<_FaqCategory> get _filtered {
    final q = _query.toLowerCase().trim();
    if (q.isEmpty) return _kFaqCategories;

    return _kFaqCategories
        .map((cat) {
          final matchingItems = cat.items.where((item) {
            return item.question.toLowerCase().contains(q) ||
                item.answer.toLowerCase().contains(q);
          }).toList();
          return _FaqCategory(cat.title, cat.icon, matchingItems);
        })
        .where((cat) =>
            cat.items.isNotEmpty ||
            cat.title.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      appBar: AppTopBar(
        title: 'Support Center',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar — pinned at the top
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: CustomTextField(
                controller: _searchController,
                hintText: 'Search for help topics...',
                suffixIcon: _query.isEmpty
                    ? const Icon(Icons.search_rounded, color: AppColors.pitx_blue)
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                      ),
                suffixIconPadding: const EdgeInsets.only(right: 8),
                suffixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ),
            // FAQ list — scrollable
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        'No results for "$_query".',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      itemCount: results.length,
                      itemBuilder: (context, catIndex) {
                        final category = results[catIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category header
                            Padding(
                              padding: const EdgeInsets.only(top: 16, bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    category.icon,
                                    size: 18,
                                    color: AppColors.pitx_blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    category.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Expandable Q&A items
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: AppColors.pitx_blue.withOpacity(0.10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  for (int i = 0; i < category.items.length; i++) ...[
                                    if (i > 0)
                                      Divider(
                                        height: 1,
                                        color: AppColors.pitx_blue.withOpacity(0.10),
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                    ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      title: Text(
                                        category.items[i].question,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category.items[i].answer,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                            height: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
