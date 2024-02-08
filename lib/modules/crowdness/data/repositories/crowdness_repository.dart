import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pilgrimpal_app/core/errors/failure.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/datasources/crowdness_datasource.dart';
import 'package:dartz/dartz.dart';

class CrowdnessRepository {
  final CrowdnessDatasource datasource;

  CrowdnessRepository({required this.datasource});

  Future<Either<Failure, Map<String, double>>> getCrowdAreas() async {
    try {
      final res = await datasource.getCrowdAreas();
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
