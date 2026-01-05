import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../navigation/app_navigator.dart';
import '../routes/app_routes.dart';

/// Shared bottom navigation bar widget
class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(
                context,
                Icons.home,
                'Home',
                0,
                _isCurrentRoute(context, AppRoutes.home),
              ),
              _buildNavItem(
                context,
                Icons.category_outlined,
                'Category',
                1,
                _isCurrentRoute(context, AppRoutes.categories),
              ),
              _buildNavItem(
                context,
                Icons.shopping_bag_outlined,
                'Orders',
                2,
                _isCurrentRoute(context, AppRoutes.orders),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isCurrentRoute(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (routeName == AppRoutes.home) {
      // Home route includes both home and products
      return currentRoute == AppRoutes.home || currentRoute == AppRoutes.products;
    }
    return currentRoute == routeName;
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    bool isSelected,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          switch (index) {
            case 0:
              // Home - navigate to home route
              if (!_isCurrentRoute(context, AppRoutes.home)) {
                AppNavigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.home,
                  predicate: (route) => route.settings.name == AppRoutes.home,
                );
              }
              break;
            case 1:
              // Category
              if (!_isCurrentRoute(context, AppRoutes.categories)) {
                AppNavigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.categories,
                  predicate: (route) => route.settings.name == AppRoutes.categories,
                );
              }
              break;
            case 2:
              // Orders
              if (!_isCurrentRoute(context, AppRoutes.orders)) {
                AppNavigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.orders,
                  predicate: (route) => route.settings.name == AppRoutes.orders,
                );
              }
              break;
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
              size: screenWidth < 290 ? 22 : 26,
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryRed : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: screenWidth < 290 ? 10 : 12,
                color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

