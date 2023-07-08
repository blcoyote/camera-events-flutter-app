urlFormatter(String hostname, String path, [Map<String, dynamic>? params]) {
  return Uri.https(hostname, path, params);
}
