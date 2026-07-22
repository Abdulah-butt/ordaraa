import '../../../../../core/navigation/route_params.dart';

class ApplicationReceivedInitialParams extends RouteParams {
  const ApplicationReceivedInitialParams({
    required this.businessName,
    required this.abn,
    required this.phoneNumber,
  });

  final String businessName;
  final String abn;
  final String phoneNumber;

  @override
  Map<String, dynamic> toMap() => {
    'businessName': businessName,
    'abn': abn,
    'phoneNumber': phoneNumber,
  };

  static ApplicationReceivedInitialParams fromMap(Map<String, dynamic> map) {
    return ApplicationReceivedInitialParams(
      businessName: map['businessName'] ?? '',
      abn: map['abn'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
