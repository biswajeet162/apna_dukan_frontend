import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../providers/product_provider.dart';

/// Account screen sample page
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final displayName = user?.name ?? 'User';
    final email = user?.email ?? 'No email';
    final initial = user?.initial ?? 'U';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (authProvider.isAuthenticated && user != null) ...[
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryRed,
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Guest View
                      Expanded(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'You are not logged in',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => AppNavigator.toLogin(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Login / Sign Up',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Menu Items
              _buildMenuSection(
                title: 'Account Settings',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Addresses',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.payment_outlined,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildMenuSection(
                title: 'Support',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.headset_mic_outlined,
                    title: 'Contact Us',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildMenuSection(
                title: 'Legal',
                items: [
                  _MenuItem(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Logout Button
              if (authProvider.isAuthenticated && user != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final authProvider = context.read<AuthProvider>();
                      final orderProvider = context.read<OrderProvider>();
                      final productProvider = context.read<ProductProvider>();

                      // Clear auth data and tokens
                      await authProvider.logout();
                      
                      // Clear other provider data
                      orderProvider.clearData();
                      productProvider.reset();

                      // Navigate to login screen and clear navigation stack
                      if (context.mounted) {
                        AppNavigator.toLoginClearStack(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
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
          child: Column(
            children: items.map((item) {
              final isLast = items.last == item;
              return InkWell(
                onTap: item.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

