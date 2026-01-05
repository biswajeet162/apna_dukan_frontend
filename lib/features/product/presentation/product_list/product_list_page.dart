import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card_enhanced.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/constants/app_colors.dart';

/// Product list page - shows only product grid
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        context.read<ProductProvider>().loadProducts(refresh: true);
      }
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<ProductProvider>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _buildProductList(),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null && provider.products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to load products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.loadProducts(refresh: true),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final products = provider.products;

        if (products.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadProducts(refresh: true),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Header
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 60,
                floating: false,
                pinned: false,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  centerTitle: false,
                  titlePadding: EdgeInsets.only(left: 16, bottom: 16),
                ),
              ),
              // Just for You Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Just for You',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Product Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: () {
                      final width = MediaQuery.of(context).size.width;
                      if (width < 380) return 0.50;
                      if (width < 410) return 0.52;
                      return 0.58;
                    }(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= products.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final product = products[index];
                      return ProductCardEnhanced(
                        product: product,
                        onTap: () {
                          AppNavigator.toProductDetail(context, product.id);
                        },
                      );
                    },
                    childCount: products.length + (provider.isLoadingMore ? 1 : 0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

