import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/user_role.dart';
import '../otp_verification/otp_verification_initial_params.dart';
import 'phone_login_initial_params.dart';
import 'phone_login_navigator.dart';
import 'phone_login_state.dart';

class PhoneLoginCubit extends Cubit<PhoneLoginState> {
  PhoneLoginCubit({required this.navigator, required this.snackBar})
    : super(PhoneLoginState.initial());

  final PhoneLoginNavigator navigator;
  final AppSnackBar snackBar;
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

  void sendCode() {
    if (!state.isPhoneValid) {
      snackBar.error('Please enter a valid WhatsApp number');
      return;
    }
    navigator.openOtpVerification(
      OtpVerificationInitialParams(
        phoneNumber: state.phoneNumber.trim(),
        role: role,
      ),
    );
  }

  void dispose() {}
}
