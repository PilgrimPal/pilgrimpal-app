import 'package:flutter/material.dart';

class CrowdnessPage extends StatelessWidget {
  const CrowdnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crowdness"),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 4,
        children: [
          InkWell(
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
