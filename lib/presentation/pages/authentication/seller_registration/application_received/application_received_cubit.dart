import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/alert/app_snack_bar.dart';
import '../../phone_login/phone_login_initial_params.dart';
import 'application_received_initial_params.dart';
import 'application_received_navigator.dart';
import 'application_received_state.dart';

class ApplicationReceivedCubit extends Cubit<ApplicationReceivedState> {
  ApplicationReceivedCubit({required this.navigator, required this.snackBar})
    : super(ApplicationReceivedState.initial());

  final ApplicationReceivedNavigator navigator;
  final AppSnackBar snackBar;

  void onInit(ApplicationReceivedInitialParams initialParams) {}

  void checkStatus() {
    snackBar.info('Your application is pending review');
  }

  void backToSignIn() {
    navigator.openPhoneLogin(const PhoneLoginInitialParams());
  }
}
