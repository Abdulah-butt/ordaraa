import '../../network/request_model/checkout_request.dart';
import '../entities/checkout_preview.dart';
import '../repositories/database/remote_database_repository.dart';

class PreviewCheckoutUseCase {
  const PreviewCheckoutUseCase(this._repository);

  final RemoteDatabaseRepository _repository;

  Future<CheckoutPreview> execute({required CheckoutRequest request}) {
    return _repository.previewCheckout(request: request);
  }
}
