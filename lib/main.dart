import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pilgrimpal_app/core/injection.dart' as di;
import 'package:pilgrimpal_app/core/routes.dart';
import 'package:pilgrimpal_app/modules/assistant/presentation/bloc/providers/assistant_provider.dart';
import 'package:pilgrimpal_app/modules/crowdness/presentation/bloc/providers/crowdness_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<CrowdnessProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<AssistantProvider>()),
      ],
      child: MaterialApp(
        title: 'PilgrimPal',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          primarySwatch: Colors.yellow,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        routes: routes,
        initialRoute: homeRoute,
      ),
    );
  }
}
