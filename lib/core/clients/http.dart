import 'package:dio/dio.dart';

class HttpClient {
  final Dio dio;
  final String sessionId;

  HttpClient({required this.dio, required this.sessionId});

  Dio get client => dio;
  String get session => sessionId;

  String parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        return 'Request to API server was cancelled';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with API server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in connection with API server';
      case DioExceptionType.connectionTimeout:
        return 'Connection to API server timed out';
      case DioExceptionType.badCertificate:
        return 'Invalid SSL certificate';
      case DioExceptionType.badResponse:
        return 'Received invalid response from API server';
      case DioExceptionType.connectionError:
        return 'Error connecting to API server';
      case DioExceptionType.unknown:
        return 'Unknown error occurred';
    }
  }
}
