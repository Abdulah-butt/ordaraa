import 'file_field.dart';

abstract class NetworkRepository {
  Future<dynamic> sendRequest(
    final String endpoint, {
    final NetworkRequestMode mode = NetworkRequestMode.get,
    final Map<String, dynamic> parameters,
    final dynamic body,
    final bool isFormData = false,
    final bool returnFullResponse = false,
    final List<FileField>? fileFields,
  });
}

enum NetworkRequestMode {
  post("POST"),
  get("GET"),
  delete("DELETE"),
  put("PUT"),
  patch("PATCH"),
  head("HEAD"),
  options("OPTIONS"),
  trace("TRACE"),
  connect("CONNECT");

  const NetworkRequestMode(this.title);

  final String title;
}
