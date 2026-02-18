import 'package:alegria_flutter/features/daily_report/data/daily_report_remote_datasource.dart';
import 'package:alegria_flutter/features/daily_report/data/daily_report_repository.dart';
import 'package:alegria_flutter/features/daily_report/models/daily_report_model.dart';

class DailyReportRepositoryImpl implements DailyReportRepository {
  final DailyReportRemoteDatasource remoteDatasource;

  DailyReportRepositoryImpl(this.remoteDatasource);

  @override
  Future<DailyReportModel> getDailyReport() {
    return remoteDatasource.getDailyReport();
  }
}
