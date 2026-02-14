import 'package:alegria_flutter/core/api/api_service.dart';
import 'package:alegria_flutter/features/dashboard/models/sales_invoice_request_model.dart';

class SalesInvoiceRequestRemoteDatasource {
  final ApiService apiService;

  SalesInvoiceRequestRemoteDatasource(this.apiService);

  Future<Map<String, dynamic>> createSalesInvoice(
    SalesInvoiceRequestModel request,
  ) async {
    final response = await apiService.post(
      '/api/sales-invoices',
      data: request.toJson(),
    );
    return response.data;
  }
}
