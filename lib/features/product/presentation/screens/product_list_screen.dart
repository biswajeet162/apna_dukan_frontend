import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/flash_sale_card.dart';
import '../widgets/product_card_enhanced.dart';
import 'product_detail_screen.dart';
import 'category_screen.dart';
import 'account_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/bottom_navigation_bar.dart';

/// Helper class for pinned search bar
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) => false;
}

/// Home screen matching the exact design
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Fashion', 'icon': Icons.checkroom, 'color': AppColors.primaryRed},
    {'name': 'Tech', 'icon': Icons.devices_other, 'color': Colors.purple},
    {'name': 'Home', 'icon': Icons.home_outlined, 'color': Colors.green},
    {'name': 'Beauty', 'icon': Icons.brush_outlined, 'color': Colors.green.shade700},
    {'name': 'Sports', 'icon': Icons.sports_esports_outlined, 'color': Colors.orange},
  ];

  // Timer state for flash sale
  int _hours = 2;
  int _minutes = 14;
  int _seconds = 59;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        context.read<ProductProvider>().loadProducts(refresh: true);
      }
    });
    _scrollController.addListener(_onScroll);
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _seconds--;
          if (_seconds < 0) {
            _seconds = 59;
            _minutes--;
            if (_minutes < 0) {
              _minutes = 59;
              _hours--;
              if (_hours < 0) {
                _hours = 0;
                _minutes = 0;
                _seconds = 0;
              }
            }
          }
        });
        _startTimer();
      }
    });
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

  String _formatTimer() {
    return '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildHomeScreenWithScrollableHeader(),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }

  Widget _buildHomeScreenWithScrollableHeader() {
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
        final flashSalePercentages = [60.0, 85.0, 40.0, 70.0, 55.0];

        return RefreshIndicator(
          onRefresh: () => provider.loadProducts(refresh: true),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Collapsible Header with Name, Cart, Notification
              SliverAppBar(
                expandedHeight: 80,
                floating: false,
                pinned: false,
                snap: false,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeader(),
                ),
              ),
              // Pinned Search Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchBarDelegate(
                  child: _buildSearchBar(),
                ),
              ),
              // Summer Sale Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                    vertical: 12,
                  ),
                  child: _buildSummerSaleBanner(),
                ),
              ),
              // Categories Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: _buildCategoriesSection(provider),
                ),
              ),
              // Flash Sale Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                    vertical: 8,
                  ),
                  child: _buildFlashSaleSection(products, flashSalePercentages),
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

  Widget _buildHomeContentWidget() {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.products.isEmpty) {
          return const SizedBox(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.error != null && provider.products.isEmpty) {
          return SizedBox(
            height: 400,
            child: Center(
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
            ),
          );
        }

        if (provider.products.isEmpty) {
          return const SizedBox(
            height: 400,
            child: Center(
              child: Text('No products found'),
            ),
          );
        }

        final products = provider.products;
        final flashSalePercentages = [60.0, 85.0, 40.0, 70.0, 55.0];

        return Column(
          children: [
            // Summer Sale Banner
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                vertical: 12,
              ),
              child: _buildSummerSaleBanner(),
            ),
            // Categories Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _buildCategoriesSection(provider),
            ),
            // Flash Sale Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                vertical: 8,
              ),
              child: _buildFlashSaleSection(products, flashSalePercentages),
            ),
            // Just for You Section
            Padding(
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
            // Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                itemCount: products.length + (provider.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
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
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          // Avatar with "B" - Clickable to navigate to Account
          GestureDetector(
            onTap: () {
              AppNavigator.toAccount(context);
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryRed,
              ),
              child: const Center(
                child: Text(
                  'B',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width < 290 ? 8 : 12),
          // Greeting and name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 290 ? 10 : 12,
                    color: AppColors.textGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Biswa Mandal',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Notification icon with purple dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: MediaQuery.of(context).size.width < 290 ? 20 : 24,
                ),
                onPressed: () {},
                padding: EdgeInsets.all(MediaQuery.of(context).size.width < 290 ? 4 : 8),
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width < 290 ? 4 : 8,
                top: MediaQuery.of(context).size.width < 290 ? 4 : 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Cart icon with red badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.textPrimary,
                  size: MediaQuery.of(context).size.width < 290 ? 20 : 24,
                ),
                onPressed: () {},
                padding: EdgeInsets.all(MediaQuery.of(context).size.width < 290 ? 4 : 8),
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width < 290 ? 2 : 6,
                top: MediaQuery.of(context).size.width < 290 ? 4 : 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
        vertical: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _handleSearch,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Find products, brands...',
                  hintStyle: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textGrey,
                    size: MediaQuery.of(context).size.width < 290 ? 18 : 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                    vertical: MediaQuery.of(context).size.width < 290 ? 8 : 12,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width < 290 ? 4 : 8,
              ),
              height: MediaQuery.of(context).size.width < 290 ? 28 : 32,
              width: MediaQuery.of(context).size.width < 290 ? 28 : 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_none,
                size: MediaQuery.of(context).size.width < 290 ? 16 : 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummerSaleBanner() {
    return Container(
      height: MediaQuery.of(context).size.width < 290 ? 140 : 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2C2C), Color(0xFF5A2BFF), Color(0xFFFF6584)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width < 290 ? 12 : 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 10,
                      vertical: MediaQuery.of(context).size.width < 290 ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'SUMMER VIBES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width < 290 ? 9 : 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width < 290 ? 4 : 8),
                Flexible(
                  child: Text(
                    'Summer Sale',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width < 290 ? 20 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width < 290 ? 4 : 8),
                Flexible(
                  child: Text(
                    'Up to 50% off on vibrant collections',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: MediaQuery.of(context).size.width < 290 ? 11 : 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width < 290 ? 6 : 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width < 290 ? 16 : 20,
                      vertical: MediaQuery.of(context).size.width < 290 ? 8 : 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Shop Now',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(ProductProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = index == _selectedCategoryIndex;
              return Padding(
                padding: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                    if (index == 0) {
                      provider.loadProducts(refresh: true);
                    } else {
                      provider.getProductsByCategory(index);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (category['color'] as Color).withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? (category['color'] as Color)
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          size: 28,
                          color: isSelected
                              ? (category['color'] as Color)
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFlashSaleSection(List products, List<double> flashSalePercentages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(
                    Icons.flash_on,
                    color: AppColors.primaryRed,
                    size: MediaQuery.of(context).size.width < 290 ? 16 : 20,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width < 290 ? 4 : 6),
                  Flexible(
                    child: Text(
                      'Flash Sale',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width < 290 ? 6 : 12),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width < 290 ? 6 : 10,
                        vertical: MediaQuery.of(context).size.width < 290 ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.purple.shade100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                            color: Colors.deepPurple.shade700,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width < 290 ? 2 : 4),
                          Flexible(
                            child: Text(
                              _formatTimer(),
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 290 ? 10 : 12,
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width < 290 ? 4 : 8),
              ),
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length.clamp(0, 5),
            separatorBuilder: (_, __) => SizedBox(
              width: MediaQuery.of(context).size.width < 290 ? 8 : 12,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width < 290 ? 4 : 0,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return FlashSaleCard(
                product: product,
                soldPercentage: flashSalePercentages[index % flashSalePercentages.length],
                onTap: () {
                  AppNavigator.toProductDetail(context, product.id);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Old method - can be removed if not used elsewhere
  Widget _buildHomeContent() {
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

        if (provider.products.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }

        final products = provider.products;
        // Mock sold percentages for flash sale items
        final flashSalePercentages = [60.0, 85.0, 40.0, 70.0, 55.0];

        return RefreshIndicator(
          onRefresh: () => provider.loadProducts(refresh: true),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Summer Sale Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                    vertical: 12,
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.width < 290 ? 140 : 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2C2C2C), Color(0xFF5A2BFF), Color(0xFFFF6584)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width < 290 ? 12 : 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SUMMER VIBES tag
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 10,
                                    vertical: MediaQuery.of(context).size.width < 290 ? 4 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'SUMMER VIBES',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width < 290 ? 9 : 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width < 290 ? 4 : 8),
                              // Summer Sale text
                              Flexible(
                                child: Text(
                                  'Summer Sale',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width < 290 ? 20 : 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width < 290 ? 4 : 8),
                              // Description
                              Flexible(
                                child: Text(
                                  'Up to 50% off on vibrant collections',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: MediaQuery.of(context).size.width < 290 ? 11 : 13,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.width < 290 ? 6 : 8),
                              // Shop Now button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryRed,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width < 290 ? 16 : 20,
                                    vertical: MediaQuery.of(context).size.width < 290 ? 8 : 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Categories Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = index == _selectedCategoryIndex;
                            return Padding(
                              padding: EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryIndex = index;
                                  });
                                  if (index == 0) {
                                    provider.loadProducts(refresh: true);
                                  } else {
                                    provider.getProductsByCategory(index);
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 56,
                                      width: 56,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (category['color'] as Color).withOpacity(0.1)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isSelected
                                              ? (category['color'] as Color)
                                              : Colors.grey.shade300,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Icon(
                                        category['icon'] as IconData,
                                        size: 28,
                                        color: isSelected
                                            ? (category['color'] as Color)
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      category['name'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Flash Sale Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flash Sale Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flash_on,
                                  color: AppColors.primaryRed,
                                  size: MediaQuery.of(context).size.width < 290 ? 16 : 20,
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width < 290 ? 4 : 6),
                                Flexible(
                                  child: Text(
                                    'Flash Sale',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width < 290 ? 6 : 12),
                                Flexible(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width < 290 ? 6 : 10,
                                      vertical: MediaQuery.of(context).size.width < 290 ? 4 : 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.purple.shade100),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.timer_outlined,
                                          size: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                                          color: Colors.deepPurple.shade700,
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width < 290 ? 2 : 4),
                                        Flexible(
                                          child: Text(
                                            _formatTimer(),
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width < 290 ? 10 : 12,
                                              color: Colors.deepPurple.shade700,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width < 290 ? 4 : 8),
                            ),
                            child: Text(
                              'See All',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Flash Sale Products
                      SizedBox(
                        height: 240,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length.clamp(0, 5),
                          separatorBuilder: (_, __) => SizedBox(
                            width: MediaQuery.of(context).size.width < 290 ? 8 : 12,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width < 290 ? 4 : 0,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return FlashSaleCard(
                              product: product,
                              soldPercentage: flashSalePercentages[index % flashSalePercentages.length],
                              onTap: () {
                                AppNavigator.toProductDetail(context, product.id);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
                    // Responsive aspect ratio based on screen width
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
