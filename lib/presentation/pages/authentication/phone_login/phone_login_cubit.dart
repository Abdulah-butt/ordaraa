import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../domain/usecases/request_phone_otp_use_case.dart';
import '../../../../network/request_model/request_phone_otp_request.dart';
import '../otp_verification/otp_verification_initial_params.dart';
import 'phone_login_initial_params.dart';
import 'phone_login_navigator.dart';
import 'phone_login_state.dart';

class PhoneLoginCubit extends Cubit<PhoneLoginState> {
  PhoneLoginCubit({
    required this.navigator,
    required this.snackBar,
    required this.requestPhoneOtpUseCase,
  }) : super(PhoneLoginState.initial());

  final PhoneLoginNavigator navigator;
  final AppSnackBar snackBar;
  final RequestPhoneOtpUseCase requestPhoneOtpUseCase;
  UserRole role = UserRole.buyer;

  void onInit(PhoneLoginInitialParams initialParams) {
    role = initialParams.role;
  }

  void onPhoneChanged(String countryCode, String phoneNumber, bool isValid) {
    emit(
      state.copyWith(
        phoneNumber: '+$countryCode$phoneNumber',
        isPhoneValid: isValid,
      ),
    );
  }

  Future<void> sendCode() async {
    if (!state.isPhoneValid) {
      snackBar.error('Please enter a valid WhatsApp number');
      return;
    }
    if (state.loading) return;

    emit(state.copyWith(loading: true));
    try {
      final phoneNumber = state.phoneNumber.trim();
      await requestPhoneOtpUseCase.execute(
        request: RequestPhoneOtpRequest(phoneNumber: phoneNumber),
      );
      navigator.openOtpVerification(
        OtpVerificationInitialParams(phoneNumber: phoneNumber, role: role),
      );
    } catch (error) {
      snackBar.error(error.toString());
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void dispose() {}
}
