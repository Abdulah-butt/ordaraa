import 'package:dio/dio.dart';

 String kDefaultCountryCode="";
class IpService {
  final Dio _dio = Dio();
  Future<void> initialize() async {
    try {
      final response = await _dio.get('http://ip-api.com/json');
      if (response.statusCode == 200) {
        kDefaultCountryCode = response.data['countryCode'] ?? 'PK';
      }
    } catch (e) {
      // Fallback to default if detection fails
      print('Failed to detect country: $e');
    }
  }
}
