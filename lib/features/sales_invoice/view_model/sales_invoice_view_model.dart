import 'package:alegria_flutter/features/sales_invoice/data/sales_invoice_repository.dart';
import 'package:alegria_flutter/features/sales_invoice/models/sales_invoice_model.dart';
import 'package:flutter/material.dart';

class SalesInvoiceViewModel extends ChangeNotifier {
  final SalesInvoiceRepository _repository;

  SalesInvoiceViewModel(this._repository);

  List<SalesInvoiceModel> _invoices = [];
  List<SalesInvoiceModel> get invoices => _invoices;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _invoices = await _repository.getInvoices();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  List<SalesInvoiceModel> get filteredInvoices {
    return _invoices.where((invoice) {
      final invoiceDate = invoice.invoiceDate.toLocal();

      return invoiceDate.year == _selectedDate.year &&
          invoiceDate.month == _selectedDate.month &&
          invoiceDate.day == _selectedDate.day;
    }).toList();
  }
}
