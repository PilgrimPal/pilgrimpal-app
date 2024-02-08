import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pilgrimpal_app/core/errors/failure.dart';
import 'package:pilgrimpal_app/modules/assistant/data/datasources/assistant_datasource.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_detail.dart';
import 'package:pilgrimpal_app/modules/assistant/data/viewmodels/chat_title.dart';

class AssistantRepository {
  final AssistantDatasource datasource;

  AssistantRepository({required this.datasource});

  Future<Either<Failure, List<ChatTitle>>> getChatTitles() async {
    try {
      final res = await datasource.getChatTitles();
      return Right(res);
    } on SocketException {
      return Left(Failure(message: 'No Internet Connection'));
    } on DioException catch (e) {
      return Left(Failure(message: datasource.http.parseDioError(e)));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, ChatDetail>> getChatDetail(String sessionId) async {
    try {
      final res = await datasource.getChatDetail(sessionId);
      return Right(res);
    } on SocketException {
      return Left(Failure(message: 'No Internet Connection'));
    } on DioException catch (e) {
      return Left(Failure(message: datasource.http.parseDioError(e)));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
