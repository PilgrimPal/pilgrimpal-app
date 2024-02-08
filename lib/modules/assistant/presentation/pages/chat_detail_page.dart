import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/providers/assistant_provider.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late AssistantProvider _assistantProvider;
  late String _sessionId;
  late String _title;

  final ScrollController _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: RefreshIndicator(
        onRefresh: () async {
          await _assistantProvider.getChatDetail(_sessionId);
        },
        child: FutureBuilder(future: Future(() async {
          await _assistantProvider.getChatDetail(_sessionId);
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
                              mainAxisAlignment: _assistantProvider
                                          .chatDetail.messages[i].type ==
                                      "ai"
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _assistantProvider
                                                .chatDetail.messages[i].type ==
                                            "ai"
                                        ? Colors.deepPurpleAccent
                                        : Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  constraints: BoxConstraints.loose(
                                    const Size.fromWidth(320),
                                  ),
                                  child: Text(
                                    _assistantProvider
                                        .chatDetail.messages[i].content,
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
                          itemCount:
                              _assistantProvider.chatDetail.messages.length,
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
                constraints: BoxConstraints.tight(const Size.fromHeight(100)),
              ),
            ],
          );
        }),
      ),
    );
  }
}
