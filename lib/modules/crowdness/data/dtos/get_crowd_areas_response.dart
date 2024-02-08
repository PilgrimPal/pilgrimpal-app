class GetCrowdAreasResponse {
  Map<String, double> crowdAreas;

  GetCrowdAreasResponse({required this.crowdAreas});

  factory GetCrowdAreasResponse.fromJson(Map<String, dynamic> json) {
    Map<String, double> map = {};
    for (var item in json.entries) {
      map[item.key] = item.value;
    }

    return GetCrowdAreasResponse(crowdAreas: map);
  }
}
