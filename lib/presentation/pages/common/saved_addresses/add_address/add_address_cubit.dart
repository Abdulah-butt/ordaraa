import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_picker_plus/location_picker_plus.dart';

import '../../../../../core/alert/app_snack_bar.dart';
import '../../../../../core/enums/address_type.dart';
import '../../../../../domain/entities/address.dart';
import '../../../../../domain/usecases/add_address_use_case.dart';
import '../../../../../domain/usecases/update_address_use_case.dart';
import '../../../../../network/request_model/add_address_request.dart';
import '../../../../../network/request_model/update_address_request.dart';
import '../../../../../services/address_location/address_location_service.dart';
import 'add_address_initial_params.dart';
import 'add_address_navigator.dart';
import 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit({
    required this.navigator,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.addressLocationService,
    required this.snackBar,
  }) : super(AddAddressState.initial());

  final AddAddressNavigator navigator;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final AddressLocationService addressLocationService;
  final AppSnackBar snackBar;

  final labelController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactPhoneController = TextEditingController();
  final line1Controller = TextEditingController();
  final line2Controller = TextEditingController();
  final cityController = TextEditingController();
  final regionController = TextEditingController();
  final postalCodeController = TextEditingController();
  String? _addressId;
  int _selectionVersion = 0;

  void onInit(AddAddressInitialParams initialParams) {
    _selectionVersion++;
    _clearControllers();
    final address = initialParams.address;
    _addressId = address?.id;
    if (address == null) {
      emit(AddAddressState.initial());
      return;
    }
    labelController.text = address.label ?? '';
    contactNameController.text = address.contactName ?? '';
    contactPhoneController.text = address.contactPhone ?? '';
    line1Controller.text = address.line1;
    line2Controller.text = address.line2 ?? '';
    cityController.text = address.city;
    regionController.text = address.state ?? '';
    postalCodeController.text = address.postalCode ?? '';
    emit(
      AddAddressState.initial().copyWith(
        type: address.type,
        countryCode: address.countryCode,
        countryName: address.countryCode,
        isDefault: address.isDefault,
        isEditing: true,
      ),
    );
    _restoreLocationSelection(address, _selectionVersion);
  }

  void setType(AddressType? type) {
    if (type != null) emit(state.copyWith(type: type));
  }

  void setDefault(bool value) {
    emit(state.copyWith(isDefault: value));
  }

  void selectCountry(CountryModel? country) {
    if (country == null) return;
    _selectionVersion++;
    regionController.clear();
    cityController.clear();
    emit(
      state.copyWith(
        countryCode: country.sortName.toUpperCase(),
        countryName: country.name,
        selectedCountry: () => country,
        selectedState: () => null,
        selectedCity: () => null,
        checkingCities: false,
        cityPickerAvailable: false,
      ),
    );
  }

  Future<void> selectState(StateModel? region) async {
    if (region == null) return;
    _selectionVersion++;
    final version = _selectionVersion;
    regionController.text = region.name;
    cityController.clear();
    emit(
      state.copyWith(
        selectedState: () => region,
        selectedCity: () => null,
        checkingCities: true,
        cityPickerAvailable: false,
      ),
    );
    try {
      final cities = await addressLocationService.getCities(region.id);
      if (isClosed || version != _selectionVersion) return;
      emit(
        state.copyWith(
          checkingCities: false,
          cityPickerAvailable: cities.isNotEmpty,
        ),
      );
    } catch (_) {
      if (isClosed || version != _selectionVersion) return;
      emit(state.copyWith(checkingCities: false, cityPickerAvailable: false));
    }
  }

  void selectCity(CityModel? city) {
    if (city == null) return;
    cityController.text = city.name;
    emit(state.copyWith(selectedCity: () => city));
  }

  Future<void> submit() async {
    if (state.submitting) return;
    final line1 = line1Controller.text.trim();
    final city = cityController.text.trim();
    if (line1.isEmpty || city.isEmpty || state.countryCode.isEmpty) {
      snackBar.error('Enter the street address, city, and country');
      return;
    }

    emit(state.copyWith(submitting: true));
    try {
      final request = AddAddressRequest(
        type: state.type,
        label: _optional(labelController),
        contactName: _optional(contactNameController),
        contactPhone: _optional(contactPhoneController),
        line1: line1,
        line2: _optional(line2Controller),
        city: city,
        state: _optional(regionController),
        postalCode: _optional(postalCodeController),
        countryCode: state.countryCode,
        isDefault: state.isDefault,
      );
      final address = state.isEditing
          ? await updateAddressUseCase.execute(
              addressId: _addressId!,
              request: UpdateAddressRequest.fromCreate(request),
            )
          : await addAddressUseCase.execute(request: request);
      snackBar.success(state.isEditing ? 'Address updated' : 'Address added');
      if (navigator.context.mounted) navigator.closeWithAddress(address);
    } catch (error) {
      emit(state.copyWith(submitting: false));
      snackBar.error(error.toString());
    }
  }

  String? _optional(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  Future<void> _restoreLocationSelection(Address address, int version) async {
    try {
      final country = await addressLocationService.findCountry(
        address.countryCode,
      );
      if (country == null) return;
      final region = address.state == null
          ? null
          : await addressLocationService.findState(
              countryId: country.id,
              name: address.state!,
            );
      final cities = region == null
          ? const <CityModel>[]
          : await addressLocationService.getCities(region.id);
      CityModel? city;
      for (final candidate in cities) {
        if (candidate.name.toLowerCase() == address.city.toLowerCase()) {
          city = candidate;
          break;
        }
      }
      if (isClosed || version != _selectionVersion) return;
      emit(
        state.copyWith(
          countryName: country.name,
          selectedCountry: () => country,
          selectedState: () => region,
          selectedCity: () => city,
          checkingCities: false,
          cityPickerAvailable: cities.isNotEmpty,
        ),
      );
    } catch (_) {
      // Preserve the existing values if an offline dataset lookup fails.
    }
  }

  void _clearControllers() {
    labelController.clear();
    contactNameController.clear();
    contactPhoneController.clear();
    line1Controller.clear();
    line2Controller.clear();
    cityController.clear();
    regionController.clear();
    postalCodeController.clear();
  }
}
