class ChatTitle {
  final String id;
  final DateTime createdAt;
  final String sessionId;
  final String title;

  ChatTitle({
    required this.id,
    required this.createdAt,
    required this.sessionId,
    required this.title,
  });

  factory ChatTitle.fromMap(Map<String, dynamic> map) => ChatTitle(
        id: map["id"],
        createdAt: DateTime.tryParse(map["created_at"]) ?? DateTime(1970, 1, 1),
        sessionId: map["session_id"],
        title: map["title"],
      );
}
