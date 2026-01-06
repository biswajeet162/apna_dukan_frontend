import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Sale banner widget for dashboard
class SaleBannerWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const SaleBannerWidget({
    super.key,
    this.title = 'Summer Sale',
    this.subtitle = 'Up to 50% off on vibrant collections',
    this.buttonText = 'Shop Now',
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 10,
                        vertical: MediaQuery.of(context).size.width < 290 ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'SUMMER VIBES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width < 290 ? 8 : 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width < 290 ? 4 : 8),
                  Flexible(
                    child: Text(
                      title,
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
                      subtitle,
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onButtonPressed ?? () {},
                    child: Text(
                      buttonText ?? 'Shop Now',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Decorative circles
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              right: -50,
              bottom: -50,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

