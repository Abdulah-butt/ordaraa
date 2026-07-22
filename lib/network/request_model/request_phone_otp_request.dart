import '../../core/enums/otp_channel.dart';

class RequestPhoneOtpRequest {
  const RequestPhoneOtpRequest({
    required this.phoneNumber,
    this.channel = OtpChannel.whatsapp,
  });

  final String phoneNumber;
  final OtpChannel channel;

  Map<String, dynamic> toJson() => {
    'phone': phoneNumber,
    'channel': channel.name,
  };
}
