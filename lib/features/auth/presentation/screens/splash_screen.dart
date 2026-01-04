import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/app_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Wait for AuthProvider to finish its _init (persisted tokens)
    // We give it a small delay to ensure providers are initialized
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (!mounted) return;

    // Only redirect if we are still on the splash screen and it's THE CURRENT route
    // If a deep link (like #/register) was pushed on top, isCurrent will be false.
    if (ModalRoute.of(context)?.isCurrent ?? false) {
       Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogoWidget(size: 100),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
