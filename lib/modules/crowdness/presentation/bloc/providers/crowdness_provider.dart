import 'package:flutter/material.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/repositories/crowdness_repository.dart';

class CrowdnessProvider with ChangeNotifier {
  final CrowdnessRepository repository;

  CrowdnessProvider({required this.repository});

  Map<String, double> _crowdAreas = {};

  Map<String, double> get crowdAreas => _crowdAreas;

  Future<void> getCrowdAreas() async {
    final res = await repository.getCrowdAreas();
    res.fold(
      (failure) => {},
      (crowdAreas) => _crowdAreas = crowdAreas,
    );

    notifyListeners();
  }
}
