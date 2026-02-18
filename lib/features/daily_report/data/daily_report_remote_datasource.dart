import 'package:alegria_flutter/core/api/api_service.dart';
import 'package:alegria_flutter/features/daily_report/models/daily_report_model.dart';

class DailyReportRemoteDatasource {
  final ApiService apiService;

  DailyReportRemoteDatasource(this.apiService);

  Future<DailyReportModel> getDailyReport() async {
    final response = await apiService.get("/api/sales-invoices/daily-report");

    return DailyReportModel.fromJson(response.data);
  }
}
