import 'package:alegria_flutter/features/sales_invoice/data/sales_invoice_remote_data_source.dart';
import 'package:alegria_flutter/features/sales_invoice/data/sales_invoice_repository.dart';
import 'package:alegria_flutter/features/sales_invoice/models/sales_invoice_model.dart';

class SalesInvoiceRepositoryImpl implements SalesInvoiceRepository {
  final SalesInvoiceRemoteDataSource remoteDatasource;

  SalesInvoiceRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<SalesInvoiceModel>> getInvoices() {
    return remoteDatasource.getInvoices();
  }
}
