import 'package:pilgrimpal_app/core/clients/http.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/dtos/get_crowd_areas_response.dart';

class CrowdnessDatasource {
  final HttpClient http;

  CrowdnessDatasource({required this.http});

  Future<Map<String, double>> getCrowdAreas() async {
    const uri = "/api/crowd/areas";
    final res = await http.client.get<Map<String, dynamic>>(uri);

    return GetCrowdAreasResponse.fromJson(res.data!).crowdAreas;
  }
}
