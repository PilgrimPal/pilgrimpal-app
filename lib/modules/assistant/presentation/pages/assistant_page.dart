import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilgrimpal_app/core/routes.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/providers/assistant_provider.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/states/send_chat_state.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssitantPageState();
}

class _AssitantPageState extends State<AssistantPage> {
  late AssistantProvider _assistantProvider;

  final DateFormat _sameDayTimeFormat = DateFormat("HH:mm");
  final DateFormat _timeFormat = DateFormat("EE");

  final _sendChatFormKey = GlobalKey<FormState>();

  String? _prompt;

  @override
  void initState() {
    _assistantProvider = context.read<AssistantProvider>();
    _assistantProvider.getChatTitles();
    super.initState();
  }

  String formatTime(DateTime dateTime) {
    if (DateUtils.isSameDay(DateTime.now(), dateTime)) {
      return _sameDayTimeFormat.format(dateTime);
    }
    return _timeFormat.format(dateTime);
  }

  Future<void> sendChat() async {
    if (!_sendChatFormKey.currentState!.validate()) {
      return;
    }

    final sessionId = const Uuid().v4();

    await _assistantProvider.sendChat(sessionId, _prompt!);

    if (_assistantProvider.sendChatState is SendChatOkState) {
      _sendChatFormKey.currentState?.reset();
      if (mounted) {
        Navigator.of(context).pushNamed(chatDetailRoute, arguments: {
          "sessionId": sessionId,
          "title": Provider.of<AssistantProvider>(context, listen: false)
              .sendChatResponse
              .title,
        });
      }
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
      appBar: AppBar(title: const Text("Assistant")),
      body: RefreshIndicator(
        onRefresh: () async {
          await _assistantProvider.getChatTitles();
        },
        child: FutureBuilder(
          future: _assistantProvider.getChatTitles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) => ListTile(
                        onTap: ([bool mounted = true]) async {
                          await Navigator.of(context).pushNamed(
                            chatDetailRoute,
                            arguments: {
                              "sessionId":
                                  _assistantProvider.chatTitles[i].sessionId,
                              "title": _assistantProvider.chatTitles[i].title,
                            },
                          );

                          if (mounted) {
                            await _assistantProvider.getChatTitles();
                          }
                        },
                        tileColor: Theme.of(context).cardColor,
                        title: Text(
                          _assistantProvider.chatTitles[i].title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                        trailing: Text(formatTime(
                            _assistantProvider.chatTitles[i].createdAt)),
                        shape: const Border.symmetric(
                          horizontal: BorderSide(
                            width: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      itemCount: _assistantProvider.chatTitles.length,
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
          },
        ),
      ),
    );
  }
}
