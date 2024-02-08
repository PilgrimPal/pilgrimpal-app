import 'package:dio/dio.dart';

class HttpClient {
  final Dio dio;
  final String sessionId;

  HttpClient({required this.dio, required this.sessionId});

  Dio get client => dio;
  String get session => sessionId;
}
