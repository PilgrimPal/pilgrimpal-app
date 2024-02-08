import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilgrimpal_app/core/routes.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/providers/assistant_provider.dart';
import 'package:provider/provider.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssitantPageState();
}

class _AssitantPageState extends State<AssistantPage> {
  late AssistantProvider _assistantProvider;

  final DateFormat _sameDayTimeFormat = DateFormat("HH:mm");
  final DateFormat _timeFormat = DateFormat("EE");

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

            return SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (ctx, i) => ListTile(
                  onTap: ([bool mounted = true]) async {
                    await Navigator.of(context).pushNamed(
                      chatDetailRoute,
                      arguments: {
                        "sessionId": _assistantProvider.chatTitles[i].sessionId,
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
                  trailing: Text(
                      formatTime(_assistantProvider.chatTitles[i].createdAt)),
                  shape: const Border.symmetric(
                    horizontal: BorderSide(
                      width: 0.5,
                      color: Colors.grey,
                    ),
                  ),
                ),
                itemCount: _assistantProvider.chatTitles.length,
              ),
            );
          },
        ),
      ),
    );
  }
}
