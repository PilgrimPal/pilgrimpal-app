import "package:envied/envied.dart";

part "env.g.dart";

@Envied(path: ".env", obfuscate: true)
abstract class Env {
  @EnviedField(varName: "SERVER_URL")
  static final String serverUrl = _Env.serverUrl;
  @EnviedField(varName: "WEBSOCKET_URL")
  static final String websocketUrl = _Env.websocketUrl;
}
