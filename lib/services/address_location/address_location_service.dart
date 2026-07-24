import 'package:location_picker_plus/location_picker_plus.dart';

abstract class AddressLocationService {
  Future<CountryModel?> findCountry(String countryCode);

  Future<StateModel?> findState({
    required String countryId,
    required String name,
  });

  Future<List<CityModel>> getCities(String stateId);
}
