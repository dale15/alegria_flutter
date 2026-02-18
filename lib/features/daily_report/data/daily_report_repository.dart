import 'package:alegria_flutter/features/daily_report/models/daily_report_model.dart';

abstract class DailyReportRepository {
  Future<DailyReportModel> getDailyReport();
}
