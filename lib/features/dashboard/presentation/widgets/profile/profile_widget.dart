import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/navigation/app_navigator.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';

/// Profile widget showing user avatar and greeting
class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final isAuthenticated = authProvider.isAuthenticated && user != null;
    final displayName = user?.firstName ?? '';
    final initial = user?.initial ?? '';
    final screenWidth = MediaQuery.of(context).size.width;
    // Reduce width slightly on wide screens
    final maxWidth = screenWidth > 640 ? 900.0 : screenWidth - 16;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
        vertical: 12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            children: [
              if (isAuthenticated) ...[
                // Avatar with Initial - Clickable to navigate to Account
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
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(
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
                        displayName,
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
              ] else ...[
                // Login button for guests
                ElevatedButton(
                  onPressed: () => AppNavigator.toLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(80, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
              ],
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
                      decoration: const BoxDecoration(
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
        ),
      ),
    );
  }
}

