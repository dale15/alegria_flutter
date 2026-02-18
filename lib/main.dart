import 'package:alegria_flutter/core/api/api_service.dart';
import 'package:alegria_flutter/features/daily_report/data/daily_report_remote_datasource.dart';
import 'package:alegria_flutter/features/daily_report/data/daily_report_repository_impl.dart';
import 'package:alegria_flutter/features/daily_report/view_model/daily_report_view_model.dart';
import 'package:alegria_flutter/features/dashboard/data/category/category_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/category/category_repository_impl.dart';
import 'package:alegria_flutter/features/dashboard/data/discount/discount_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/discount/discount_repository_impl.dart';
import 'package:alegria_flutter/features/dashboard/data/product/product_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/product/product_repository_impl.dart';
import 'package:alegria_flutter/features/dashboard/data/sales_invoice/sales_invoice_request_remote_datasource.dart';
import 'package:alegria_flutter/features/dashboard/data/sales_invoice/sales_invoice_request_repository_impl.dart';
import 'package:alegria_flutter/features/dashboard/view_models/cart_view_model.dart';
import 'package:alegria_flutter/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:alegria_flutter/features/sales_invoice/data/sales_invoice_remote_data_source.dart';
import 'package:alegria_flutter/features/sales_invoice/data/sales_invoice_repository_impl.dart';
import 'package:alegria_flutter/features/sales_invoice/view_model/sales_invoice_view_model.dart';
import 'package:alegria_flutter/features/splashscreen/view_models/splash_view_model.dart';
import 'package:alegria_flutter/features/splashscreen/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();

  final categoryRemote = CategoryRemoteDatasource(apiService);
  final categoryReposity = CategoryRepositoryImpl(categoryRemote);

  final productRemote = ProductRemoteDatasource(apiService);
  final productRepository = ProductRepositoryImpl(productRemote);

  final discountRemote = DiscountRemoteDatasource(apiService);
  final discountRepository = DiscountRepositoryImpl(discountRemote);

  final salesInvoiceRequestRemote = SalesInvoiceRequestRemoteDatasource(
    apiService,
  );
  final salesInvoiceRequestRepository = SalesInvoiceRequestRepositoryImpl(
    salesInvoiceRequestRemote,
  );

  final salesInvoiceRemote = SalesInvoiceRemoteDataSource(
    apiService: apiService,
  );
  final salesInvoiceRepository = SalesInvoiceRepositoryImpl(salesInvoiceRemote);

  final dailyReportRemote = DailyReportRemoteDatasource(apiService);
  final dailyReportRepository = DailyReportRepositoryImpl(dailyReportRemote);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            categoryReposity,
            productRepository,
            discountRepository,
          )..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartViewModel(salesInvoiceRequestRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesInvoiceViewModel(salesInvoiceRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => DailyReportViewModel(dailyReportRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alegria Bakeshop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      home: Scaffold(body: SafeArea(child: SplashView())),
    );
  }
}
