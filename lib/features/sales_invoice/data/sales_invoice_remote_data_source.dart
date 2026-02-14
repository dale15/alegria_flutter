import 'package:alegria_flutter/core/api/api_service.dart';
import 'package:alegria_flutter/features/sales_invoice/models/sales_invoice_model.dart';

class SalesInvoiceRemoteDataSource {
  final ApiService apiService;

  SalesInvoiceRemoteDataSource({required this.apiService});

  Future<List<SalesInvoiceModel>> getInvoices() async {
    final response = await apiService.get('/api/sales-invoices');

    return (response.data as List)
        .map((e) => SalesInvoiceModel.fromJson(e))
        .toList();
  }
}
