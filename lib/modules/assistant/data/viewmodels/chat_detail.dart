class ChatDetail {
  final String title;
  final List<ChatMessage> messages;

  ChatDetail({required this.title, required this.messages});

  factory ChatDetail.fromMap(Map<String, dynamic> map) => ChatDetail(
        title: map["title"],
        messages: List<ChatMessage>.from(
          map["messages"].map((msg) => ChatMessage.fromMap(msg)),
        ),
      );
}

class ChatMessage {
  final String type;
  final String content;

  ChatMessage({required this.type, required this.content});

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        type: map["type"],
        content: map["content"],
      );
}
