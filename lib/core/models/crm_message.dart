class CrmMessageSender {
  final int id;
  final String name;

  CrmMessageSender({required this.id, required this.name});

  factory CrmMessageSender.fromJson(Map<String, dynamic> json) {
    return CrmMessageSender(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class CrmMessageAttachment {
  final int id;
  final String originalName;
  final String? mimeType;
  final int sizeBytes;
  final String url;

  CrmMessageAttachment({
    required this.id,
    required this.originalName,
    this.mimeType,
    required this.sizeBytes,
    required this.url,
  });

  factory CrmMessageAttachment.fromJson(Map<String, dynamic> json) {
    return CrmMessageAttachment(
      id: json['id'] as int,
      originalName: json['original_name'] as String,
      mimeType: json['mime_type'] as String?,
      sizeBytes: (json['size_bytes'] as num).toInt(),
      url: json['url'] as String,
    );
  }
}

class CrmMessage {
  final int id;
  final int threadId;
  final String body;
  final bool isInternal;
  final CrmMessageSender? sender;
  final List<CrmMessageAttachment> attachments;
  final String? createdAtHuman;

  CrmMessage({
    required this.id,
    required this.threadId,
    required this.body,
    required this.isInternal,
    this.sender,
    required this.attachments,
    this.createdAtHuman,
  });

  factory CrmMessage.fromJson(Map<String, dynamic> json) {
    return CrmMessage(
      id: json['id'] as int,
      threadId: json['thread_id'] as int,
      body: json['body'] as String,
      isInternal: json['is_internal'] as bool,
      sender: json['sender'] != null
          ? CrmMessageSender.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((a) => CrmMessageAttachment.fromJson(a as Map<String, dynamic>))
          .toList(),
      createdAtHuman: json['created_at_human'] as String?,
    );
  }
}
