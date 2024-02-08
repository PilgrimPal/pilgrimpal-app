import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_detail.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/providers/assistant_provider.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/states/send_chat_state.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late AssistantProvider _assistantProvider;
  late ChatDetail _chatDetail;
  late String _sessionId;
  late String _title;

  final ScrollController _scrollController = ScrollController();
  final _sendChatFormKey = GlobalKey<FormState>();

  String? _prompt;

  @override
  void initState() {
    _assistantProvider = context.read<AssistantProvider>();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    var args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    _sessionId = args["sessionId"]!;
    _title = args["title"]!;
    super.didChangeDependencies();
  }

  Future<void> sendChat() async {
    if (!_sendChatFormKey.currentState!.validate()) {
      return;
    }

    await _assistantProvider.sendChat(_sessionId, _prompt!);

    if (_assistantProvider.sendChatState is SendChatOkState) {
      await _assistantProvider.getChatDetail(_sessionId);
      setState(() {
        _chatDetail = _assistantProvider.chatDetail;
      });

      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.decelerate);
      _sendChatFormKey.currentState?.reset();
    } else {
      final message =
          (_assistantProvider.sendChatState as SendChatFailureState).message;

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: RefreshIndicator(
        onRefresh: () async {
          await _assistantProvider.getChatDetail(_sessionId);
          setState(() {
            _chatDetail = _assistantProvider.chatDetail;
          });
        },
        child: FutureBuilder(future: Future(() async {
          await _assistantProvider.getChatDetail(_sessionId);
          _chatDetail = _assistantProvider.chatDetail;
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.decelerate);
        }), builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  reverse: true,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment:
                                  _chatDetail.messages[i].type == "ai"
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _chatDetail.messages[i].type == "ai"
                                        ? Colors.deepPurpleAccent
                                        : Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  constraints: BoxConstraints.loose(
                                    const Size.fromWidth(280),
                                  ),
                                  child: Text(
                                    _chatDetail.messages[i].content,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: _assistantProvider.chatDetail
                                                  .messages[i].type ==
                                              "ai"
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          itemCount: _chatDetail.messages.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1),
                  ),
                ),
                constraints: BoxConstraints.tight(const Size.fromHeight(140)),
                child: Form(
                  key: _sendChatFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              contentPadding: const EdgeInsets.all(6),
                            ),
                            onChanged: (String? val) {
                              _prompt = val?.trim();
                            },
                            onSaved: (String? val) {
                              _prompt = val?.trim();
                            },
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return "Can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Provider.of<AssistantProvider>(context).sendChatState
                                is SendChatLoadingState
                            ? const CircularProgressIndicator()
                            : IconButton.filled(
                                onPressed: sendChat,
                                icon: const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.white,
                                ),
                                color: Colors.deepPurpleAccent,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
