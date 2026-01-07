import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../widgets/product_card_enhanced.dart';

/// Product detail page - shows product details
class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedImageIndex = 0;
  bool _isDescriptionExpanded = false;
  int _quantity = 1;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getProductById(widget.productId);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: _buildBottomBar(context),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.productDetail == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (provider.error != null && provider.productDetail == null) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.getProductById(widget.productId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final product = provider.productDetail;
          if (product == null) {
            return const Scaffold(
              body: Center(child: Text('Product not found')),
            );
          }

          // Safely get imageUrls with defensive checks
          final imageUrls = product.imageUrls;
          final safeImageUrls = imageUrls.where((url) => url.isNotEmpty).toList();

          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: safeImageUrls.isNotEmpty
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: safeImageUrls.length,
                              onPageChanged: (index) {
                                if (mounted) {
                                  setState(() {
                                    _selectedImageIndex = index.clamp(0, safeImageUrls.length - 1).toInt();
                                  });
                                }
                              },
                              itemBuilder: (context, index) {
                                if (index >= 0 && index < safeImageUrls.length) {
                                  return Image.network(
                                    safeImageUrls[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.image_not_supported),
                                      );
                                    },
                                  );
                                }
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                            if (safeImageUrls.length > 1)
                              Positioned.fill(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 8),
                                    _buildBlurArrow(
                                      isLeft: true,
                                      enabled: _selectedImageIndex > 0,
                                      onTap: () {
                                        if (_selectedImageIndex > 0) {
                                          final target = _selectedImageIndex - 1;
                                          _pageController.animateToPage(
                                            target,
                                            duration: const Duration(milliseconds: 250),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                    ),
                                    const Spacer(),
                                    _buildBlurArrow(
                                      isLeft: false,
                                      enabled: _selectedImageIndex < safeImageUrls.length - 1,
                                      onTap: () {
                                        if (_selectedImageIndex < safeImageUrls.length - 1) {
                                          final target = _selectedImageIndex + 1;
                                          _pageController.animateToPage(
                                            target,
                                            duration: const Duration(milliseconds: 250),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            if (safeImageUrls.length > 1)
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(safeImageUrls.length, (index) {
                                    final bool isActive = index == _selectedImageIndex;
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      width: isActive ? 16 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 100),
                        ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Implement share functionality
                    },
                  ),
                ],
              ),
              // Product Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width < 290 ? 12 : 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Product Name
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width < 290 ? 18 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Rating and Reviews
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber[700],
                            size: MediaQuery.of(context).size.width < 290 ? 16 : 20,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width < 290 ? 3 : 4),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width < 290 ? 6 : 8),
                          Text(
                            '(${product.reviewsCount.toString()} reviews)',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey.shade300, height: 32),
                      // Price
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 290 ? 20 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          if (product.mrp > product.price) ...[
                            SizedBox(width: MediaQuery.of(context).size.width < 290 ? 8 : 12),
                            Text(
                              '₹${product.mrp.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 18,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width < 290 ? 6 : 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width < 290 ? 6 : 8,
                                vertical: MediaQuery.of(context).size.width < 290 ? 3 : 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.width < 290 ? 10 : 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Stock + Category quick info
                      Row(
                        children: [
                          Icon(
                            product.stock > 0 ? Icons.check_circle : Icons.cancel,
                            color: product.stock > 0 ? Colors.green : Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              product.stock > 0
                                  ? 'In Stock (${product.stock} available)'
                                  : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 15,
                                color: product.stock > 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.category, size: 20, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              product.categoryName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey.shade300, height: 32),
                      // Description collapsible
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isDescriptionExpanded = !_isDescriptionExpanded;
                              });
                            },
                            child: Text(_isDescriptionExpanded ? 'Show less' : 'Show more'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedCrossFade(
                        firstChild: Text(
                          product.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        secondChild: Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        crossFadeState: _isDescriptionExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                      ),
                      Divider(color: Colors.grey.shade300, height: 32),
                      // Related products
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Related products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (provider.isRelatedLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (provider.relatedError != null)
                        Text(
                          provider.relatedError!,
                          style: const TextStyle(color: Colors.red),
                        )
                      else if (provider.relatedProducts.isEmpty)
                        const Text('No related products found right now.')
                      else
                        SizedBox(
                          height: 260,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.relatedProducts.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final relatedProduct = provider.relatedProducts[index];
                              return SizedBox(
                                width: 190,
                                child: ProductCardEnhanced(
                                  product: relatedProduct,
                                  onTap: () => AppNavigator.toProductDetail(
                                    context,
                                    relatedProduct.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Divider(color: Colors.grey.shade300, height: 32),
                      // Reviews & comments placeholder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Reviews & Comments',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildMockReviewCard(),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _quantity = (_quantity - 1).clamp(1, 999);
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      _quantity.toString(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _quantity = (_quantity + 1).clamp(1, 999);
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                  label: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    // TODO: integrate cart add logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added $_quantity item(s) to cart')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockReviewCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: Colors.blueGrey, child: Text('A', style: TextStyle(color: Colors.white))),
              SizedBox(width: 8),
              Text('Alex M.', style: TextStyle(fontWeight: FontWeight.w600)),
              Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 18),
              Icon(Icons.star, color: Colors.amber, size: 18),
              Icon(Icons.star, color: Colors.amber, size: 18),
              Icon(Icons.star, color: Colors.amber, size: 18),
              Icon(Icons.star_half, color: Colors.amber, size: 18),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'The sneakers are super comfortable and look great. The sizing runs true and cushioning is perfect for daily runs.',
            style: TextStyle(color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurArrow({
    required bool isLeft,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: InkWell(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLeft ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

