import 'package:pilgrimpal_app/core/clients/http.dart';
import 'package:pilgrimpal_app/modules/assistant/data/dtos/get_chat_titles_response.dart';
import 'package:pilgrimpal_app/modules/assistant/data/dtos/send_chat_response.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_detail.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_title.dart';

class AssistantDatasource {
  final HttpClient http;

  AssistantDatasource({required this.http});

  Future<List<ChatTitle>> getChatTitles() async {
    const uri = "/api/chatbot/chat_titles";
    final res = await http.client.get<Map<String, dynamic>>(uri);

    return GetChatTitlesResponse.fromJson(res.data!).titles;
  }

  Future<ChatDetail> getChatDetail(String sessionId) async {
    final uri = "/api/chatbot/chat_history/$sessionId";
    final res = await http.client.get<Map<String, dynamic>>(uri);

    return ChatDetail.fromMap(res.data!);
  }

  Future<SendChatResponse> sendChat(String sessionId, String prompt) async {
    const uri = "/api/chatbot/chat";
    final res = await http.client.post(
      uri,
      data: {
        "session_id": sessionId,
        "prompt": prompt,
      },
    );

    return SendChatResponse.fromJson(res.data!);
  }
}
