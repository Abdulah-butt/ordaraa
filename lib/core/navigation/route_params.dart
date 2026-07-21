abstract class RouteParams {
  const RouteParams(); // Add generative constructor

  Map<String, dynamic> toMap();

  String toQueryString() {
    return Uri(queryParameters: toMap()).query;
  }

  static T fromQueryString<T extends RouteParams>(
      String queryString,
      T Function(Map<String, dynamic>) fromMap
      ) {
    final params = Uri.splitQueryString(queryString);
    return fromMap(params);
  }
}