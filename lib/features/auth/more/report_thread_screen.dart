import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pitx_mobapp2/core/models/crm_message.dart';
import 'package:pitx_mobapp2/core/models/crm_thread.dart';
import 'package:pitx_mobapp2/core/services/crm_service.dart';
import 'package:pitx_mobapp2/core/theme/app_colors.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_attachment_picker.dart';
import 'package:pitx_mobapp2/shared/widgets/custom_expandable_text_form_field.dart';

class ReportThreadScreen extends StatefulWidget {
  final CrmThread thread;

  const ReportThreadScreen({super.key, required this.thread});

  @override
  State<ReportThreadScreen> createState() => _ReportThreadScreenState();
}

class _ReportThreadScreenState extends State<ReportThreadScreen> {
  final _crmService = CrmService();
  final _replyController = TextEditingController();

  List<CrmMessage> _messages = [];
  List<XFile> _attachments = [];
  bool _isLoadingMessages = true;
  bool _isSending = false;
  String _errorMessage = '';

  bool get _isResolved => widget.thread.status == 'resolved';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _crmService.getMessages(widget.thread.id);
      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoadingMessages = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoadingMessages = false;
        });
      }
    }
  }

  Future<void> _sendReply() async {
    final body = _replyController.text.trim();
    if (body.isEmpty) {
      setState(() => _errorMessage = 'Please enter a message.');
      return;
    }

    setState(() {
      _isSending = true;
      _errorMessage = '';
    });

    try {
      // Send text reply
      final message = await _crmService.sendMessage(
        threadId: widget.thread.id,
        body: body,
      );

      // Upload attachments (up to 5) against the new message
      for (final file in _attachments) {
        await _crmService.uploadAttachment(
          threadId: widget.thread.id,
          messageId: message.id,
          file: file,
        );
      }

      // Clear input and reload messages
      _replyController.clear();
      if (mounted) setState(() => _attachments = []);
      await _loadMessages();
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: widget.thread.subject,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Status banner
          _StatusBanner(status: widget.thread.status),

          // Messages list
          Expanded(
            child: _isLoadingMessages
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty && _messages.isEmpty
                    ? Center(
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return _MessageBubble(message: _messages[index]);
                        },
                      ),
          ),

          // Reply input — hidden for resolved threads
          if (!_isResolved)
            _ReplyInput(
              controller: _replyController,
              isSending: _isSending,
              errorMessage: _errorMessage,
              onAttachmentsChanged: (files) => _attachments = files,
              onSend: _sendReply,
            ),
        ],
      ),
    );
  }
}

// ── Status banner ─────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final String status;

  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'resolved' => ('This report has been resolved.', Colors.green),
      'ongoing'  => ('A staff member has replied to your report.', AppColors.pitx_blue),
      _          => ('Your report is open and awaiting response.', Colors.orange),
    };

    return Container(
      width: double.infinity,
      color: color.withOpacity(0.10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Message bubble ─────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final CrmMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final senderName = message.sender?.name ?? 'Staff';
    final isStaff = message.sender == null || message.isInternal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isStaff
            ? AppColors.pitx_blue.withOpacity(0.08)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.pitx_blue.withOpacity(0.10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                senderName,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isStaff ? AppColors.pitx_blue : AppColors.textPrimary,
                ),
              ),
              Text(
                message.createdAtHuman ?? '',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(message.body, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          if (message.attachments.isNotEmpty) ...[
            const SizedBox(height: 8),
            // Horizontal image thumbnail strip
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: message.attachments.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final attachment = message.attachments[i];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      attachment.url,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      // Show broken icon on load error (bad URL, deleted file, etc.)
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.pitx_blue.withOpacity(0.08),
                        child: const Icon(Icons.broken_image_rounded,
                            color: AppColors.textSecondary),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Reply input ───────────────────────────────────────────────────────────────

class _ReplyInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final String errorMessage;
  final void Function(List<XFile>) onAttachmentsChanged;
  final VoidCallback onSend;

  const _ReplyInput({
    required this.controller,
    required this.isSending,
    required this.errorMessage,
    required this.onAttachmentsChanged,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.pitx_blue.withOpacity(0.10))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorMessage.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
          CustomExpandableTextFormField(
            labelText: 'Write a reply...',
            controller: controller,
            minLines: 2,
            maxLines: 5,
          ),
          const SizedBox(height: 8),
          CustomAttachmentPicker(
            allowMultiple: true,
            maxCount: 5,
            buttonLabel: 'Add Images (optional)',
            onAttachmentsChanged: onAttachmentsChanged,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isSending ? null : onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pitx_blue,
                disabledBackgroundColor: AppColors.pitx_blue.withOpacity(0.6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Send Reply', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
