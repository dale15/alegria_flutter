import 'package:alegria_flutter/core/services/startup_service.dart';
import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final StartupService _startupService = StartupService();

  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading

    final results = await Future.wait([
      _startupService.initializeLocalDb(),
      _startupService.checkInternet(),
    ]);

    final hasInternet = results[1] as bool;

    _isLoading = false;
    notifyListeners();
  }
}
