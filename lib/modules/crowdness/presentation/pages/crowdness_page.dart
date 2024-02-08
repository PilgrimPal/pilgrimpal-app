import 'package:flutter/material.dart';

class CrowdnessPage extends StatefulWidget {
  const CrowdnessPage({super.key});

  @override
  State<CrowdnessPage> createState() => _CrowdnessPageState();
}

class _CrowdnessPageState extends State<CrowdnessPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
