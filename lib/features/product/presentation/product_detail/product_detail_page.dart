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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ? PageView.builder(
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
                      // Image Indicators
                      if (safeImageUrls.length > 1)
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: safeImageUrls.length,
                            itemBuilder: (context, index) {
                              if (index < 0 || index >= safeImageUrls.length) {
                                return const SizedBox.shrink();
                              }
                              return GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      _selectedImageIndex = index.clamp(0, safeImageUrls.length - 1).toInt();
                                    });
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _selectedImageIndex == index
                                          ? Colors.blue
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      safeImageUrls[index],
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.image);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
                      const SizedBox(height: 24),
                      // Stock Status
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            product.stock > 0 ? Icons.check_circle : Icons.cancel,
                            color: product.stock > 0 ? Colors.green : Colors.red,
                            size: MediaQuery.of(context).size.width < 290 ? 18 : 24,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width < 290 ? 6 : 8),
                          Text(
                            product.stock > 0
                                ? 'In Stock (${product.stock} available)'
                                : 'Out of Stock',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 16,
                              color: product.stock > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Category
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Category: ',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            product.categoryName,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width < 290 ? 14 : 16,
                              color: Colors.blue[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
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
}

