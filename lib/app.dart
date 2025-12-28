import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/routes/app_routes.dart';
import 'features/product/data/sources/product_remote_source.dart';
import 'features/product/data/repositories/product_repository.dart';
import 'features/product/data/sources/category_remote_source.dart';
import 'features/product/data/repositories/category_repository.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/product/presentation/providers/category_provider.dart';
import 'features/product/presentation/screens/product_list_screen.dart';
import 'features/auth/data/sources/auth_remote_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: productProvider),
        ChangeNotifierProvider.value(value: categoryProvider),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: MaterialApp(
        title: 'Apna Dukan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.generateRoute,
        // Enable web URL handling
        builder: (context, child) {
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
