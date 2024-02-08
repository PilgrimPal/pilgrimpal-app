import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/dtos/crowd_detail.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/bloc/providers/crowdness_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CrowdDetailPage extends StatefulWidget {
  const CrowdDetailPage({super.key});

  @override
  State<CrowdDetailPage> createState() => _CrowdDetailPageState();
}

class _CrowdDetailPageState extends State<CrowdDetailPage> {
  CrowdnessProvider? _crowdnessProvider;
  late String _areaId;
  late CrowdDetail _crowdDetail;
  late VideoPlayerController _playerController;
  final DateFormat _dateFormatter = DateFormat("E, MM dd yyyy, HH:mm:ss");
  final DateFormat _timeSeriesFormat = DateFormat("HH:mm");

  @override
  void initState() {
    _crowdnessProvider = context.read<CrowdnessProvider>();
    _crowdnessProvider?.resetCrowdDetail();
    _playerController =
        VideoPlayerController.asset("assets/videos/video_umrah1.mp4");

    _playerController.initialize().then((_) {
      setState(() {});
    });
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
    _playerController.setLooping(true);
    _playerController.play();

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
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: Column(
                  children: [
                    Text(
                      "Area: $_areaId",
                      style: const TextStyle(
                          color: Colors.deepPurple, fontSize: 40),
                    ),
                    Text(
                      "Last updated at: ${_dateFormatter.format(_crowdDetail.updatedAt)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _playerController.value.isInitialized
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: VideoPlayer(_playerController),
                              ),
                            )
                          : Container(),
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
                    const Text(
                      "Crowd Density from the past 30 minutes",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 16, 12),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: LineChart(
                          LineChartData(
                            lineTouchData: const LineTouchData(enabled: false),
                            borderData: FlBorderData(
                              border: const Border(
                                left: BorderSide(),
                                bottom: BorderSide(),
                              ),
                            ),
                            minX: 0,
                            minY: 0,
                            maxY: 100,
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: const AxisTitles(
                                axisNameSize: 20,
                                axisNameWidget: Text("Density (%)"),
                              ),
                              bottomTitles: AxisTitles(
                                axisNameSize: 20,
                                axisNameWidget: const Text("Time"),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval:
                                      _crowdDetail.crowdHistory.length * 6,
                                  getTitlesWidget: (value, meta) {
                                    var time = _crowdDetail
                                        .crowdHistory.last.updatedAt
                                        .add(Duration(seconds: value.toInt()));
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child:
                                          Text(_timeSeriesFormat.format(time)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                color: Colors.deepPurple,
                                spots: _crowdDetail.crowdHistory.reversed.map(
                                  (record) {
                                    var x = record.updatedAt
                                        .difference(_crowdDetail
                                            .crowdHistory.last.updatedAt)
                                        .inSeconds
                                        .toDouble();
                                    return FlSpot(
                                      x,
                                      record.crowdDensity,
                                    );
                                  },
                                ).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
