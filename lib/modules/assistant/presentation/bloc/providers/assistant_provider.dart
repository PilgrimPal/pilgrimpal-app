import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/assistant/data/repositories/assistant_repository.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_detail.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_title.dart';

class AssistantProvider with ChangeNotifier {
  final AssistantRepository repository;

  AssistantProvider({required this.repository});

  List<ChatTitle> _chatTitles = [];
  late ChatDetail _chatDetail;

  List<ChatTitle> get chatTitles => _chatTitles;
  ChatDetail get chatDetail => _chatDetail;

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
}
