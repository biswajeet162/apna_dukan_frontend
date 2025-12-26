import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/flash_sale_card.dart';
import '../widgets/product_card_enhanced.dart';
import 'product_detail_screen.dart';
import '../../../../core/constants/app_colors.dart';

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
      context.read<ProductProvider>().loadProducts(refresh: true);
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
        child: Column(
          children: [
            // Top Header
            _buildHeader(),
            // Search Bar
            _buildSearchBar(),
            // Scrollable Content
            Expanded(
              child: _buildHomeContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar with "B"
          Container(
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
          const SizedBox(width: 12),
          // Greeting and name
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning!',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Biswa Mandal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Notification icon with purple dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
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
                icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                onPressed: () {},
              ),
              Positioned(
                right: 6,
                top: 8,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                decoration: const InputDecoration(
                  hintText: 'Find products, brands...',
                  hintStyle: TextStyle(color: AppColors.textGrey),
                  prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 8),
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic_none,
                size: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    height: 160,
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
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SUMMER VIBES tag
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'SUMMER VIBES',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              // Summer Sale text
                              const Text(
                                'Summer Sale',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Description
                              const Text(
                                'Up to 50% off on vibrant collections',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              // Shop Now button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryRed,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'Shop Now',
                                  style: TextStyle(fontWeight: FontWeight.w600),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Flash Sale Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.flash_on, color: AppColors.primaryRed, size: 20),
                              const SizedBox(width: 6),
                              const Text(
                                'Flash Sale',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.purple.shade100),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.timer_outlined, size: 14, color: Colors.deepPurple.shade700),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatTimer(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.deepPurple.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 14,
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
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return FlashSaleCard(
                              product: product,
                              soldPercentage: flashSalePercentages[index % flashSalePercentages.length],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(productId: product.id),
                                  ),
                                );
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(productId: product.id),
                            ),
                          );
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

  Widget _buildBottomNavigation() {
    int selectedIndex = 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, selectedIndex == 0),
              _buildNavItem(Icons.grid_view_outlined, 'Categories', 1, selectedIndex == 1),
              // Central purple shopping bag
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.purple.shade600,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              _buildNavItem(Icons.favorite_border, 'Saved', 2, selectedIndex == 2),
              _buildNavItem(Icons.person_outline, 'Account', 3, selectedIndex == 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Handle navigation
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 20,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryRed : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
