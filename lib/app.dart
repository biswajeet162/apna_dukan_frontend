import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/routes/app_routes.dart';
import 'core/widgets/viewport_fix.dart';
import 'features/splash/presentation/splash_page.dart';
import 'features/product/data/sources/product_remote_source.dart';
import 'features/product/data/repositories/product_repository.dart';
import 'features/product/data/sources/category_remote_source.dart';
import 'features/product/data/repositories/category_repository.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/product/presentation/providers/category_provider.dart';
import 'features/auth/data/sources/auth_remote_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/orders/data/sources/order_remote_source.dart';
import 'features/orders/data/repositories/order_repository.dart';
import 'features/orders/presentation/providers/order_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize API client
    final apiClient = ApiClient();
    
    // Initialize product dependencies
    final productRemoteSource = ProductRemoteSource(apiClient);
    final productRepository = ProductRepository(productRemoteSource);
    final productProvider = ProductProvider(productRepository);

    // Initialize category dependencies
    final categoryRemoteSource = CategoryRemoteSource(apiClient);
    final categoryRepository = CategoryRepository(categoryRemoteSource);
    final categoryProvider = CategoryProvider(categoryRepository);

    // Initialize auth dependencies
    final authRemoteSource = AuthRemoteSource(apiClient);
    final authRepository = AuthRepository(authRemoteSource);
    final authProvider = AuthProvider(authRepository, apiClient);

    // Initialize order dependencies
    final orderRemoteSource = OrderRemoteSource(apiClient);
    final orderRepository = OrderRepository(orderRemoteSource);
    final orderProvider = OrderProvider(orderRepository);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: productProvider),
        ChangeNotifierProvider.value(value: categoryProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: orderProvider),
      ],
      child: MaterialApp(
        title: 'Apna Dukan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Start at splash route once when the app launches
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
        // Enable web URL handling and viewport fix
        builder: (context, child) {
          return ViewportFix(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
