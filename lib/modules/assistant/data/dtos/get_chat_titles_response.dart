import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_title.dart';

class GetChatTitlesResponse {
  final List<ChatTitle> titles;

  GetChatTitlesResponse({required this.titles});

  factory GetChatTitlesResponse.fromJson(Map<String, dynamic> json) =>
      GetChatTitlesResponse(
        titles: List<ChatTitle>.from(
          json["titles"].map((ct) => ChatTitle.fromMap(ct)),
        ),
      );
}
