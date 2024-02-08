import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/dtos/crowd_detail.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/bloc/providers/crowdness_provider.dart';
import 'package:provider/provider.dart';

class CrowdDetailPage extends StatefulWidget {
  const CrowdDetailPage({super.key});

  @override
  State<CrowdDetailPage> createState() => _CrowdDetailPageState();
}

class _CrowdDetailPageState extends State<CrowdDetailPage> {
  CrowdnessProvider? _crowdnessProvider;
  late String _areaId;
  late CrowdDetail _crowdDetail;
  final DateFormat _dateFormatter = DateFormat("E, MM dd yyyy, HH:mm:ss");

  @override
  void initState() {
    _crowdnessProvider = context.read<CrowdnessProvider>();
    _crowdnessProvider?.resetCrowdDetail();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _areaId = ModalRoute.of(context)?.settings.arguments as String;
    super.didChangeDependencies();
  }

  Color densityColor() {
    if (_crowdDetail.crowdDensity >= 90) {
      return Colors.red;
    } else if (_crowdDetail.crowdDensity >= 60) {
      return Colors.orange;
    } else if (_crowdDetail.crowdDensity >= 30) {
      return Colors.yellow;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _crowdnessProvider?.getCrowdDetail(_areaId);
          _crowdDetail = _crowdnessProvider!.crowdDetail!;
        },
        child: FutureBuilder(
          future: Future(() async {
            await _crowdnessProvider?.getCrowdDetail(_areaId);
            _crowdDetail = _crowdnessProvider!.crowdDetail!;
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Area: $_areaId",
                    style:
                        const TextStyle(color: Colors.deepPurple, fontSize: 40),
                  ),
                  Text(
                    "Last updated at: ${_dateFormatter.format(_crowdDetail.updatedAt)}",
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 4,
                      children: [
                        Card(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _crowdDetail.crowdHistory[0].crowdCount
                                      .toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                    fontSize: 42,
                                  ),
                                ),
                                const Text(
                                  "Pilgrims",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: densityColor(),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${_crowdDetail.crowdHistory[0].crowdDensity.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 42,
                                  ),
                                ),
                                const Text(
                                  "Density",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
