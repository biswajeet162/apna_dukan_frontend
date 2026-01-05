import 'package:flutter/material.dart';
import '../../../core/widgets/app_navbar.dart';
import '../../product/presentation/product_list/product_list_page.dart';

/// Home page - shows product list
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const ProductListPage(),
      bottomNavigationBar: const AppNavbar(),
    );
  }
}
