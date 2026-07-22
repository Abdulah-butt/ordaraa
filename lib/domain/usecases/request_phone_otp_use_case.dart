import '../../network/request_model/request_phone_otp_request.dart';
import '../repositories/database/remote_database_repository.dart';

class RequestPhoneOtpUseCase {
  const RequestPhoneOtpUseCase(this._remoteDatabaseRepository);

  final RemoteDatabaseRepository _remoteDatabaseRepository;

  Future<void> execute({required RequestPhoneOtpRequest request}) {
    return _remoteDatabaseRepository.requestPhoneOtp(request: request);
  }
}
