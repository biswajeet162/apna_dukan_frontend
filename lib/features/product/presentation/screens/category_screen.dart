import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/category_provider.dart';
import '../providers/product_provider.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_list_model.dart';
import '../widgets/product_card_enhanced.dart';
import 'product_detail_screen.dart';

/// Category screen with left sidebar and right content
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProductListModel> _categoryProducts = [];
  bool _isLoadingProducts = false;

  @override
  void initState() {
    super.initState();
    // Load categories when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final categoryProvider = context.read<CategoryProvider>();
      await categoryProvider.loadCategories();
      // Load products for the first selected category
      if (categoryProvider.selectedCategory != null) {
        _loadCategoryProducts(categoryProvider.selectedCategory!.id);
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
    // Implement pagination if needed
  }

  Future<void> _loadCategoryProducts(int categoryId) async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      await context.read<ProductProvider>().getProductsByCategory(categoryId);
      setState(() {
        _categoryProducts = context.read<ProductProvider>().products;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar - Full Width, Outside Scroll
          _buildSearchBar(),
          // Main Content with Sidebar
          Expanded(
            child: Row(
              children: [
                // Left Sidebar - Categories
                _buildCategorySidebar(),
                // Right Content Area
                Expanded(
                  child: _buildContentArea(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySidebar() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return const SizedBox(
            width: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (categoryProvider.error != null) {
          return SizedBox(
            width: 100,
            child: Center(
              child: Text(
                categoryProvider.error!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final categories = categoryProvider.flatCategories;
        final selectedCategory = categoryProvider.selectedCategory;

        return Container(
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              right: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory?.id == category.id;

              return _buildCategorySidebarItem(category, isSelected, () async {
                categoryProvider.selectCategory(category);
                await _loadCategoryProducts(category.id);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildCategorySidebarItem(
    CategoryModel category,
    bool isSelected,
    VoidCallback onTap,
  ) {
    // Map category names to icons
    IconData getIconForCategory(String name) {
      final lowerName = name.toLowerCase();
      if (lowerName.contains('fashion')) return Icons.checkroom;
      if (lowerName.contains('grocery')) return Icons.shopping_bag_outlined;
      if (lowerName.contains('electronics')) return Icons.devices_other;
      if (lowerName.contains('home')) return Icons.home_outlined;
      if (lowerName.contains('beauty')) return Icons.brush_outlined;
      if (lowerName.contains('toy')) return Icons.toys;
      if (lowerName.contains('for you')) return Icons.favorite_outline;
      return Icons.category_outlined;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          border: isSelected
              ? Border(
                  left: BorderSide(color: AppColors.primaryRed, width: 3),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              getIconForCategory(category.name),
              color: isSelected ? AppColors.primaryRed : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primaryRed : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentArea() {
    return Consumer2<CategoryProvider, ProductProvider>(
      builder: (context, categoryProvider, productProvider, child) {
        return _buildScrollableContent(categoryProvider, productProvider);
      },
    );
  }

  Widget _buildSearchBar() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for products...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.mic_none, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent(
    CategoryProvider categoryProvider,
    ProductProvider productProvider,
  ) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Collapsible Category Title
        SliverAppBar(
          expandedHeight: 60,
          floating: false,
          pinned: false,
          snap: false,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              'Categories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
                fontSize: 20,
              ),
            ),
            centerTitle: false,
            titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
        // Summer Sale Banner
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSummerSaleBanner(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        // Popular Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildPopularSection(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        // Category Products Section
        if (categoryProvider.selectedCategory != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader(
                categoryProvider.selectedCategory!.name,
                onSeeAll: () {},
              ),
            ),
          ),
        if (_isLoadingProducts)
          const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (!_isLoadingProducts && _categoryProducts.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = _categoryProducts[index];
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
                childCount: _categoryProducts.length,
              ),
            ),
          ),
        if (!_isLoadingProducts && _categoryProducts.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text(
                  'No products found in this category',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildSummerSaleBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'NEW ARRIVALS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summer Sale',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '50% Off',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Popular', onSeeAll: () {}),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPopularCard(
                'Sneakers',
                '2.1k items',
                'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPopularCard(
                'T-Shirts',
                '5k+ items',
                'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPopularCard(String title, String subtitle, String imageUrl) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
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
    );
  }
}
