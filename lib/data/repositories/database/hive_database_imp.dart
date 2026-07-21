import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/repositories/database/local_database_repository.dart';

class HiveDatabaseImp implements LocalDatabaseRepository {
  final String authBoxName = "authBox";

  Box get _authBox => Hive.box(authBoxName);

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    await Hive.openBox(authBoxName);

    debugPrint("++++++++++ INITIALIZED LOCAL DATABASE +++++++++++");
  }

  @override
  Future<String> getAccessToken() async {
    try {
      return await _authBox.get('access_token') ?? "";
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<String> getRefreshToken() async {
    try {
      return await _authBox.get('refresh_token') ?? "";
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> saveAccessToken(String token) async {
    return await _authBox.put('access_token',token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _authBox.put('refresh_token', token);
  }

  @override
  Future<void> logoutUser() async {
    await _authBox.clear();
  }
}
