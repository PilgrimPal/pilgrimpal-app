class SendChatResponse {
  final String title;
  final String response;

  SendChatResponse({required this.title, required this.response});

  factory SendChatResponse.fromJson(Map<String, dynamic> json) =>
      SendChatResponse(
        title: json["title"],
        response: json["response"],
      );
}
