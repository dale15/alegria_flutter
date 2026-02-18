import 'package:alegria_flutter/features/daily_report/data/daily_report_repository.dart';
import 'package:alegria_flutter/features/daily_report/models/daily_report_model.dart';
import 'package:flutter/material.dart';

class DailyReportViewModel extends ChangeNotifier {
  final DailyReportRepository _repository;

  DailyReportViewModel(this._repository);

  DailyReportModel? _dailyReport;
  DailyReportModel? get dailyReport => _dailyReport;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadReport() async {
    try {
      _dailyReport = await _repository.getDailyReport();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
