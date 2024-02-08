import 'package:dio/dio.dart';
import 'package:pilgrimpal_app/core/clients/http.dart';

class CrowdnessDatasource {
  final HttpClient http;

  CrowdnessDatasource({required this.http});

  Future<Response<Map<String, double>>> getCrowdAreas() async {
    const uri = "/crowd/areas";
    final res = await http.client.get<Map<String, double>>(uri);

    return res;
  }
}
