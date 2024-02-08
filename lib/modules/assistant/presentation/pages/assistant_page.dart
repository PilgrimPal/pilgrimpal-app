import 'package:flutter/material.dart';

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssitantPageState();
}

class _AssitantPageState extends State<AssistantPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assistant")),
      body: Column(
        children: [],
      ),
    );
  }
}
