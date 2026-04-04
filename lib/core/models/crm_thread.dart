class CrmThread {
  final int id;
  final String subject;
  final String category;
  final bool isClosed;
  // Derived by backend: 'open' | 'ongoing' | 'resolved'
  final String status;
  final int messagesCount;
  final int? firstMessageId;
  final String? createdAtHuman;
  final String? lastMessageAtHuman;
  final String? closedAtHuman;

  CrmThread({
    required this.id,
    required this.subject,
    required this.category,
    required this.isClosed,
    required this.status,
    required this.messagesCount,
    this.firstMessageId,
    this.createdAtHuman,
    this.lastMessageAtHuman,
    this.closedAtHuman,
  });

  factory CrmThread.fromJson(Map<String, dynamic> json) {
    return CrmThread(
      id: json['id'] as int,
      subject: json['subject'] as String,
      category: json['category'] as String,
      isClosed: json['is_closed'] as bool,
      status: json['status'] as String? ?? 'open',
      messagesCount: (json['messages_count'] as num?)?.toInt() ?? 0,
      firstMessageId: (json['first_message_id'] as num?)?.toInt(),
      createdAtHuman: json['created_at_human'] as String?,
      lastMessageAtHuman: json['last_message_at_human'] as String?,
      closedAtHuman: json['closed_at_human'] as String?,
    );
  }
}
