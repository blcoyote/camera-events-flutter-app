import '../app_config.dart';

urlFormatter(String hostname, String path, [Map<String, dynamic>? params]) {

  if (AppConfig.protocol == 'http') {
    return Uri.http(hostname, path, params);
  }
  return Uri.https(hostname, path, params);
}
