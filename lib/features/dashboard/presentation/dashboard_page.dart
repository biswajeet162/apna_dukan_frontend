import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/widgets/bottom_navigation_bar.dart';
import '../../product/presentation/providers/product_provider.dart';
import '../../product/presentation/widgets/product_card_enhanced.dart';
import 'widgets/header/search_bar_widget.dart';
import 'widgets/profile/profile_widget.dart';
import 'widgets/sale_banner_widget.dart';

/// Dashboard page - Main landing page with search, profile, sale banner, and products
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load products when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts(refresh: true);
    });

    // Setup scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<ProductProvider>().loadMoreProducts();
    }
  }

  void _handleSearch(String keyword) {
    if (keyword.isEmpty) {
      context.read<ProductProvider>().loadProducts(refresh: true);
    } else {
      context.read<ProductProvider>().searchProducts(keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<ProductProvider>(
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

            // Profile hides on scroll; search bar stays pinned.
            return RefreshIndicator(
              onRefresh: () => provider.loadProducts(refresh: true),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Profile (scrolls away)
                  const SliverToBoxAdapter(
                    child: ProfileWidget(),
                  ),
                  // Sticky Search Bar
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SearchHeaderDelegate(
                      child: SearchBarWidget(
                        controller: _searchController,
                        onChanged: _handleSearch,
                      ),
                    ),
                  ),
                  // Sale Banner
                  SliverToBoxAdapter(
                    child: SaleBannerWidget(
                      onButtonPressed: () {
                        // Navigate to products or categories
                      },
                    ),
                  ),
                  // Products Grid
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                      vertical: 8,
                    ),
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final product = products[index];
                          return ProductCardEnhanced(
                            product: product,
                            onTap: () {
                              AppNavigator.toProductDetail(
                                context,
                                product.id,
                              );
                            },
                          );
                        },
                        childCount: products.length +
                            (provider.isLoadingMore ? 1 : 0),
                      ),
                    ),
                  ),
                  // Loading indicator at bottom
                  if (provider.isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }
}

/// Delegate to keep the search bar pinned at the top while scrolling.
class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchHeaderDelegate({required this.child});

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: maxExtent,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) => false;
}
