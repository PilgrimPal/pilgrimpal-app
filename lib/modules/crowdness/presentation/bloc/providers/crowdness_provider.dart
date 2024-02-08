import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/dtos/crowd_detail.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/repositories/crowdness_repository.dart';

class CrowdnessProvider with ChangeNotifier {
  final CrowdnessRepository repository;

  CrowdnessProvider({required this.repository});

  Map<String, double> _crowdAreas = {};
  CrowdDetail? _crowdDetail;

  Map<String, double> get crowdAreas => _crowdAreas;
  CrowdDetail? get crowdDetail => _crowdDetail;

  Future<void> getCrowdAreas() async {
    final res = await repository.getCrowdAreas();
    res.fold(
      (failure) => {},
      (crowdAreas) => _crowdAreas = crowdAreas,
    );

    notifyListeners();
  }

  Future<void> getCrowdDetail(String areaId) async {
    final res = await repository.getCrowdDetail(areaId);
    res.fold(
      (failure) {},
      (crowdDetail) => _crowdDetail = crowdDetail,
    );

    notifyListeners();
  }

  void resetCrowdDetail() {
    _crowdDetail = null;
  }
}
