import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/services/address_location/location_picker_address_location_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = LocationPickerAddressLocationService();

  test('resolves a country and state from the offline dataset', () async {
    final country = await service.findCountry('AU');
    expect(country?.name, 'Australia');

    final state = await service.findState(
      countryId: country!.id,
      name: 'New South Wales',
    );
    expect(state?.name, 'New South Wales');

    final cities = await service.getCities(state!.id);
    expect(cities, isEmpty);
  });
}
