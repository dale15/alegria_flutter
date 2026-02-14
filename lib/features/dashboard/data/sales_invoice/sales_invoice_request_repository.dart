import 'package:alegria_flutter/features/dashboard/models/sales_invoice_request_model.dart';

abstract class SalesInvoiceRequestRepository {
  Future<Map<String, dynamic>> createSalesInvoice(
    SalesInvoiceRequestModel salesInvoiceData,
  );
}
