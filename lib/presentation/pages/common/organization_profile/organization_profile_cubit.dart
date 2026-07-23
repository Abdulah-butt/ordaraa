import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/alert/app_snack_bar.dart';
import '../../../../core/enums/payment_terms.dart';
import '../../../../domain/entities/organization.dart';
import '../../../../domain/usecases/get_current_organization_use_case.dart';
import '../../../../domain/usecases/update_organization_profile_use_case.dart';
import '../../../../network/request_model/update_organization_profile_request.dart';
import 'organization_profile_initial_params.dart';
import 'organization_profile_navigator.dart';
import 'organization_profile_state.dart';

class OrganizationProfileCubit extends Cubit<OrganizationProfileState> {
  OrganizationProfileCubit({
    required this.navigator,
    required this.getCurrentOrganizationUseCase,
    required this.updateOrganizationProfileUseCase,
    required this.snackBar,
  }) : super(OrganizationProfileState.initial());

  final OrganizationProfileNavigator navigator;
  final GetCurrentOrganizationUseCase getCurrentOrganizationUseCase;
  final UpdateOrganizationProfileUseCase updateOrganizationProfileUseCase;
  final AppSnackBar snackBar;

  final nameController = TextEditingController();
  final legalNameController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final taxNumberController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactEmailController = TextEditingController();
  final contactPhoneController = TextEditingController();

  Future<void> onInit(OrganizationProfileInitialParams initialParams) async {
    if (state.organization != null) return;
    await _load();
  }

  Future<void> retry() => _load();

  Future<void> _load() async {
    emit(state.copyWith(loading: true, errorMessage: () => null));
    try {
      final organization = await getCurrentOrganizationUseCase.execute();
      _fillControllers(organization);
      emit(
        state.copyWith(
          organization: () => organization,
          paymentTerms: () => organization.defaultPaymentTerms,
          loading: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(loading: false, errorMessage: () => error.toString()),
      );
    }
  }

  void setPaymentTerms(PaymentTerms? value) {
    emit(state.copyWith(paymentTerms: () => value));
  }

  Future<void> save() async {
    if (state.saving) return;
    final name = nameController.text.trim();
    if (name.length < 2) {
      snackBar.error('Business name must contain at least 2 characters');
      return;
    }
    final email = _optional(contactEmailController);
    if (email != null && !_isValidEmail(email)) {
      snackBar.error('Enter a valid contact email');
      return;
    }

    emit(state.copyWith(saving: true));
    try {
      final organization = await updateOrganizationProfileUseCase.execute(
        request: UpdateOrganizationProfileRequest(
          name: name,
          legalName: _optional(legalNameController),
          registrationNumber: _optional(registrationNumberController),
          taxNumber: _optional(taxNumberController),
          contactName: _optional(contactNameController),
          contactEmail: email,
          contactPhone: _optional(contactPhoneController),
          defaultPaymentTerms: state.paymentTerms,
        ),
      );
      _fillControllers(organization);
      emit(
        state.copyWith(
          organization: () => organization,
          paymentTerms: () => organization.defaultPaymentTerms,
          saving: false,
        ),
      );
      snackBar.success('Organization profile updated');
    } catch (error) {
      emit(state.copyWith(saving: false));
      snackBar.error(error.toString());
    }
  }

  void _fillControllers(Organization organization) {
    nameController.text = organization.name;
    legalNameController.text = organization.legalName ?? '';
    registrationNumberController.text = organization.registrationNumber ?? '';
    taxNumberController.text = organization.taxNumber ?? '';
    contactNameController.text = organization.contactName ?? '';
    contactEmailController.text = organization.contactEmail ?? '';
    contactPhoneController.text = organization.contactPhone ?? '';
  }

  String? _optional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  @override
  Future<void> close() {
    nameController.dispose();
    legalNameController.dispose();
    registrationNumberController.dispose();
    taxNumberController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    contactPhoneController.dispose();
    return super.close();
  }
}
