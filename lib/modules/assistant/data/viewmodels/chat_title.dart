import 'package:intl/intl.dart';

final _dateFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");

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
        createdAt:
            _dateFormatter.tryParse(map["created_at"]) ?? DateTime(1970, 1, 1),
        sessionId: map["session_id"],
        title: map["title"],
      );
}
