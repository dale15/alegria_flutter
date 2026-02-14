import 'package:alegria_flutter/features/sales_invoice/models/sales_invoice_model.dart';

abstract class SalesInvoiceRepository {
  Future<List<SalesInvoiceModel>> getInvoices();
}
