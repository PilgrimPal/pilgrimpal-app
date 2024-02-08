import "package:envied/envied.dart";

part "env.g.dart";

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: "SERVER_URL")
  static const String serverUrl = _Env.serverUrl;
  @EnviedField(varName: "WEBSOCKET_URL")
  static const String websocketUrl = _Env.websocketUrl;
}
