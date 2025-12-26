import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'features/product/data/sources/product_remote_source.dart';
import 'features/product/data/repositories/product_repository.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/product/presentation/screens/product_list_screen.dart';

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: productProvider),
      ],
      child: MaterialApp(
        title: 'Apna Dukan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ProductListScreen(),
      ),
    );
  }
}
