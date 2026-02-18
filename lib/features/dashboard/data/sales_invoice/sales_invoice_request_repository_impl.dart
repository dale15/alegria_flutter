import 'package:alegria_flutter/features/dashboard/data/sales_invoice/sales_invoice_request_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/sales_invoice/sales_invoice_request_repository.dart';
import 'package:alegria_flutter/features/dashboard/models/sales_invoice_request_model.dart';

class SalesInvoiceRequestRepositoryImpl
    implements SalesInvoiceRequestRepository {
  final SalesInvoiceRequestRemoteDatasource remoteDatasource;

  SalesInvoiceRequestRepositoryImpl(this.remoteDatasource);

  @override
  Future<Map<String, dynamic>> createSalesInvoice(
    SalesInvoiceRequestModel salesInvoiceData,
  ) {
    return remoteDatasource.createSalesInvoice(salesInvoiceData);
  }
}
