import 'package:flutter/material.dart';
import '../../data/models/product_list_model.dart';
import '../../../../core/constants/app_colors.dart';

/// Enhanced product card for "Just for You" section with brand, ratings, reviews
class ProductCardEnhanced extends StatefulWidget {
  final ProductListModel product;
  final VoidCallback? onTap;

  const ProductCardEnhanced({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ProductCardEnhanced> createState() => _ProductCardEnhancedState();
}

class _ProductCardEnhancedState extends State<ProductCardEnhanced> {
  bool _isFavorited = false;

  // Mock brand names based on product ID
  String get _brandName {
    final brands = ['HERSCHEL', 'RAY-BAN', 'NESPRESSO', 'LEVI\'S', 'SONY', 'APPLE', 'SAMSUNG', 'NIKE', 'ADIDAS', 'PUMA'];
    return brands[widget.product.id % brands.length];
  }

  // Mock review count based on product ID
  int get _reviewCount {
    return (widget.product.id * 15 + 50) % 300;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image Container
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  color: AppColors.backgroundGrey,
                ),
                child: Stack(
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: widget.product.imageUrl.isNotEmpty
                          ? Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.backgroundGrey,
                                  child: const Icon(Icons.image_not_supported, size: 40),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.backgroundGrey,
                              child: const Icon(Icons.image, size: 40),
                            ),
                    ),
                    // Favorite Heart Icon (top-right)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFavorited = !_isFavorited;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorited ? AppColors.primaryRed : Colors.blue.shade300,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Product Info
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width < 410 ? 10 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand Name (Red)
                  Text(
                    _brandName,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 410 ? 10 : 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryRed,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width < 410 ? 3 : 4),
                  // Product Name
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width < 410 ? 12 : 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width < 410 ? 4 : 6),
                  // Rating and Reviews
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.product.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: MediaQuery.of(context).size.width < 410 ? 11 : 12,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width < 410 ? 3 : 4),
                      Flexible(
                        child: Text(
                          '${widget.product.rating.toStringAsFixed(1)} (${_reviewCount})',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width < 410 ? 10 : 11,
                            color: AppColors.textGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width < 410 ? 6 : 8),
                  // Price and Add Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Price Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Current Price
                            Text(
                              '₹${widget.product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width < 410 ? 14 : 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            // Original Price (Strikethrough) - if discounted
                            if (widget.product.mrp > widget.product.price)
                              Text(
                                '₹${widget.product.mrp.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width < 410 ? 11 : 12,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textGrey,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Add to Cart Button (Red Circle with +)
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${widget.product.name} added to cart'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width < 410 ? 32 : 36,
                          height: MediaQuery.of(context).size.width < 410 ? 32 : 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryRed,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width < 410 ? 18 : 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

