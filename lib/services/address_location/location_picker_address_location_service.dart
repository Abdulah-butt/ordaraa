import 'package:location_picker_plus/location_picker_plus.dart';

import 'address_location_service.dart';

class LocationPickerAddressLocationService implements AddressLocationService {
  const LocationPickerAddressLocationService();

  @override
  Future<CountryModel?> findCountry(String countryCode) async {
    final countries = await LocationService.instance.loadCountries();
    return _find(
      countries,
      (country) => country.sortName.toUpperCase() == countryCode.toUpperCase(),
    );
  }

  @override
  Future<StateModel?> findState({
    required String countryId,
    required String name,
  }) async {
    final states = await LocationService.instance.getStatesByCountryId(
      countryId,
    );
    return _find(
      states,
      (state) => state.name.toLowerCase() == name.toLowerCase(),
    );
  }

  @override
  Future<List<CityModel>> getCities(String stateId) {
    return LocationService.instance.getCitiesByStateId(stateId);
  }

  T? _find<T>(Iterable<T> values, bool Function(T value) matches) {
    for (final value in values) {
      if (matches(value)) return value;
    }
    return null;
  }
}
