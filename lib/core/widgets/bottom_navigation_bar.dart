import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../navigation/app_navigator.dart';
import '../routes/app_routes.dart';

/// Shared bottom navigation bar widget
class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock text scale so icons/labels stay visually consistent across pages
    final mediaQuery = MediaQuery.of(context);
    return MediaQuery(
      data: mediaQuery.copyWith(textScaleFactor: 1.0),
      child: Container(
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
                  'Order',
                  2,
                  _isCurrentRoute(context, AppRoutes.orders),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isCurrentRoute(BuildContext context, String routeName) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (routeName == AppRoutes.home) {
      return currentRoute == AppRoutes.home ||
          currentRoute == AppRoutes.products ||
          currentRoute == AppRoutes.dashboard;
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
    const double iconSize = 22;
    const double labelFontSize = 11;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          switch (index) {
            case 0:
              // Home - treat as dashboard and keep route name as '/dashboard'
              AppNavigator.toHomeClearStack(context);
              break;
            case 1:
              // Category
              AppNavigator.toCategories(context);
              break;
            case 2:
              // Order
              AppNavigator.toOrders(context);
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
              size: iconSize,
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
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: labelFontSize,
                  color: isSelected ? AppColors.primaryRed : AppColors.textGrey,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

