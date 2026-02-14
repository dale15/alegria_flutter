import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class StartupService {
  final InternetConnectionChecker _checker;

  final bool _isHiveInitialized = false;

  StartupService({InternetConnectionChecker? checker})
    : _checker = checker ?? InternetConnectionChecker();

  Future<bool> checkInternet() async {
    return await _checker.hasConnection;
  }

  Future<void> initializeLocalDb() async {
    if (_isHiveInitialized) return;

    try {
      await Hive.initFlutter();

      await Hive.openBox('app_settings');
    } catch (e) {
      debugPrint("Local DB Initialization Failed ❌: $e");
      rethrow;
    }
  }
}
