import '../../../core/navigation/route_params.dart';

class SplashInitialParams extends RouteParams {
  final String id;

  const SplashInitialParams({required this.id});

  @override
  Map<String, dynamic> toMap() {
    return {"id": id};
  }

  static SplashInitialParams fromMap(Map<String, dynamic> map) {
    return SplashInitialParams(id: map['id'] ?? "0");
  }
}
