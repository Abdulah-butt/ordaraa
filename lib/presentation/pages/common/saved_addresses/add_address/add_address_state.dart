import 'package:equatable/equatable.dart';
import 'package:location_picker_plus/location_picker_plus.dart';

import '../../../../../core/enums/address_type.dart';

class AddAddressState extends Equatable {
  const AddAddressState({
    required this.type,
    required this.countryCode,
    required this.countryName,
    required this.isDefault,
    required this.submitting,
    required this.isEditing,
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedCity,
    required this.checkingCities,
    required this.cityPickerAvailable,
  });

  final AddressType type;
  final String countryCode;
  final String countryName;
  final bool isDefault;
  final bool submitting;
  final bool isEditing;
  final CountryModel? selectedCountry;
  final StateModel? selectedState;
  final CityModel? selectedCity;
  final bool checkingCities;
  final bool cityPickerAvailable;

  factory AddAddressState.initial() => const AddAddressState(
    type: AddressType.delivery,
    countryCode: '',
    countryName: '',
    isDefault: false,
    submitting: false,
    isEditing: false,
    selectedCountry: null,
    selectedState: null,
    selectedCity: null,
    checkingCities: false,
    cityPickerAvailable: false,
  );

  AddAddressState copyWith({
    AddressType? type,
    String? countryCode,
    String? countryName,
    bool? isDefault,
    bool? submitting,
    bool? isEditing,
    CountryModel? Function()? selectedCountry,
    StateModel? Function()? selectedState,
    CityModel? Function()? selectedCity,
    bool? checkingCities,
    bool? cityPickerAvailable,
  }) {
    return AddAddressState(
      type: type ?? this.type,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      isDefault: isDefault ?? this.isDefault,
      submitting: submitting ?? this.submitting,
      isEditing: isEditing ?? this.isEditing,
      selectedCountry: selectedCountry == null
          ? this.selectedCountry
          : selectedCountry(),
      selectedState: selectedState == null
          ? this.selectedState
          : selectedState(),
      selectedCity: selectedCity == null ? this.selectedCity : selectedCity(),
      checkingCities: checkingCities ?? this.checkingCities,
      cityPickerAvailable: cityPickerAvailable ?? this.cityPickerAvailable,
    );
  }

  @override
  List<Object?> get props => [
    type,
    countryCode,
    countryName,
    isDefault,
    submitting,
    isEditing,
    selectedCountry,
    selectedState,
    selectedCity,
    checkingCities,
    cityPickerAvailable,
  ];
}
