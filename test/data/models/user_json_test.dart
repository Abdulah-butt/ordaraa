import 'package:flutter_test/flutter_test.dart';
import 'package:ordaraa/data/models/user_json.dart';

void main() {
  test('maps public phone and nullable email to the User entity', () {
    final model = UserJson.fromJson(const {
      'id': 'user-id',
      'phone': '+61412345678',
      'email': null,
      'displayName': 'Maya Chen',
      'avatar': null,
      'locale': 'en-AU',
      'status': 'ACTIVE',
      'platformRole': null,
    });

    final user = model.toDomain();

    expect(user.id, 'user-id');
    expect(user.phone, '+61412345678');
    expect(user.email, isNull);
    expect(model.toJson()['phone'], '+61412345678');
    expect(model.toJson()['email'], isNull);
  });

  test('copyWith supports updating and clearing email', () {
    final user = UserJson.fromJson(const {
      'id': 'user-id',
      'phone': '+61412345678',
      'email': 'buyer@ordaraa.test',
      'displayName': 'Maya Chen',
      'avatar': null,
      'locale': 'en-AU',
      'status': 'ACTIVE',
      'platformRole': null,
    }).toDomain();

    final updated = user.copyWith(phone: '+61411111111', email: () => null);

    expect(updated.phone, '+61411111111');
    expect(updated.email, isNull);
  });
}
