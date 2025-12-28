import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// App logo widget with gradient background and notification dot
class AppLogoWidget extends StatelessWidget {
  final double size;
  final bool showNotificationDot;

  const AppLogoWidget({
    super.key,
    this.size = 80,
    this.showNotificationDot = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientPurple.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_bag,
            color: Colors.white,
            size: 40,
          ),
        ),
        if (showNotificationDot)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

