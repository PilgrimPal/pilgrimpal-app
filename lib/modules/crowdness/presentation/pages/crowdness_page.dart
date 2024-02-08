import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/bloc/providers/crowdness_provider.dart';
import 'package:provider/provider.dart';

class CrowdnessPage extends StatefulWidget {
  const CrowdnessPage({super.key});

  @override
  State<CrowdnessPage> createState() => _CrowdnessPageState();
}

class _CrowdnessPageState extends State<CrowdnessPage> {
  CrowdnessProvider? _crowdnessProvider;
  List<String> keys = [];

  @override
  void initState() {
    _crowdnessProvider = context.read<CrowdnessProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crowdness"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _crowdnessProvider?.getCrowdAreas();
          keys = _crowdnessProvider?.crowdAreas.keys.toList() ?? [];
        },
        child: FutureBuilder(
          future: Future(() async {
            await _crowdnessProvider?.getCrowdAreas();
            keys = _crowdnessProvider?.crowdAreas.keys.toList() ?? [];
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: _crowdnessProvider?.crowdAreas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 4,
                  crossAxisCount: 2,
                ),
                itemBuilder: (ctx, i) => InkWell(
                  onTap: () {},
                  child: Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            keys[i],
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 40,
                            ),
                          ),
                          Text(
                            "Crowdness: ${_crowdnessProvider?.crowdAreas[keys[i]]?.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
