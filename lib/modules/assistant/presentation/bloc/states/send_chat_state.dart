abstract class SendChatState {
  const SendChatState();
}

class SendChatInitialState extends SendChatState {}

class SendChatLoadingState extends SendChatState {}

class SendChatOkState extends SendChatState {}

class SendChatFailureState extends SendChatState {
  final String message;

  SendChatFailureState([this.message = ""]) : super();
}
