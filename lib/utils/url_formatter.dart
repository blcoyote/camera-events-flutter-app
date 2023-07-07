urlFormatter(String hostname, String path, [Map<String, dynamic>? params]) {
  return Uri.http(hostname, path, params);
}
