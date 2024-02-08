import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pilgrimpal_app/core/clients/http.dart';
import 'package:pilgrimpal_app/core/env.dart';
import 'package:pilgrimpal_app/modules/assistant/data/datasources/assistant_datasource.dart';
import 'package:pilgrimpal_app/modules/assistant/data/repositories/assistant_repository.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/providers/assistant_provider.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/datasources/crowdness_datasource.dart';
import 'package:pilgrimpal_app/modules/crowdness/data/repositories/crowdness_repository.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/bloc/providers/crowdness_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final sl = GetIt.I;

Future<void> init() async {
  // Datasources
  sl.registerFactory<CrowdnessDatasource>(
    () => CrowdnessDatasource(http: sl()),
  );
  sl.registerFactory<AssistantDatasource>(
    () => AssistantDatasource(http: sl()),
  );

  // Repositories
  sl.registerFactory<CrowdnessRepository>(
    () => CrowdnessRepository(datasource: sl()),
  );
  sl.registerFactory<AssistantRepository>(
    () => AssistantRepository(datasource: sl()),
  );

  // Providers
  sl.registerFactory<CrowdnessProvider>(
    () => CrowdnessProvider(repository: sl()),
  );
  sl.registerFactory<AssistantProvider>(
    () => AssistantProvider(repository: sl()),
  );

  // Externals and third parties
  final prefs = await SharedPreferences.getInstance();

  var sessionId = prefs.getString("session_id");
  if (sessionId == null || sessionId == "") {
    sessionId = const Uuid().v4();
    await prefs.setString("session_id", sessionId);
  }

  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(
    () => HttpClient(
      dio: Dio(
        BaseOptions(
          baseUrl: Env.serverUrl,
        ),
      ),
      sessionId: sessionId!,
    ),
  );
}
