import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/assistant/data/dtos/send_chat_response.dart';
import 'package:pilgrimpal_app/modules/assistant/data/repositories/assistant_repository.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_detail.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_title.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/states/send_chat_state.dart';

class AssistantProvider with ChangeNotifier {
  final AssistantRepository repository;

  AssistantProvider({required this.repository});

  List<ChatTitle> _chatTitles = [];
  late ChatDetail _chatDetail;

  SendChatState _sendChatState = SendChatInitialState();
  late SendChatResponse _sendChatResponse;

  List<ChatTitle> get chatTitles => _chatTitles;
  ChatDetail get chatDetail => _chatDetail;

  SendChatState get sendChatState => _sendChatState;
  SendChatResponse get sendChatResponse => _sendChatResponse;

  Future<void> getChatTitles() async {
    final res = await repository.getChatTitles();
    res.fold(
      (failure) => [],
      (titles) => _chatTitles = [...titles],
    );

    notifyListeners();
  }

  Future<void> getChatDetail(String sessionId) async {
    final res = await repository.getChatDetail(sessionId);
    res.fold(
      (failure) => [],
      (chatDetail) => _chatDetail = chatDetail,
    );

    notifyListeners();
  }

  Future<void> sendChat(String sessionId, String prompt) async {
    _sendChatState = SendChatLoadingState();

    notifyListeners();

    final res = await repository.sendChat(sessionId, prompt);
    res.fold(
      (failure) => _sendChatState = SendChatFailureState(failure.message),
      (res) {
        _sendChatState = SendChatOkState();
        _sendChatResponse = res;
      },
    );
    notifyListeners();
  }

  void resetStates() {
    _sendChatState = SendChatInitialState();

    notifyListeners();
  }
}
