import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';

/// Beautiful gradient splash screen shown for ~1 second,
/// then navigates according to the current route URL.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _loaderController;
  late final Animation<double> _loaderAnimation;

  @override
  void initState() {
    super.initState();

    // Animated loader that grows from the center outwards
    _loaderController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _loaderAnimation = CurvedAnimation(
      parent: _loaderController,
      curve: Curves.easeInOut,
    );

    // Show splash for 1 second, then let routing take over.
    Timer(const Duration(seconds: 5), _navigateNext);
  }

  @override
  void dispose() {
    _loaderController.dispose();
    super.dispose();
  }

  void _navigateNext() {
    if (!mounted) return;

    final route = ModalRoute.of(context);

    // If a deep link / web URL already pushed a route on top,
    // do nothing and let that screen stay.
    if (!(route?.isCurrent ?? false)) {
      return;
    }

    // Default behaviour: go to the dashboard (which itself
    // will handle nested navigation via AppRoutes + URL).
    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF5ECFF),
                Color(0xFFF8F5FF),
                Color(0xFFFDFBFF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Soft radial glow background
              Positioned(
                top: -size.height * 0.2,
                left: -size.width * 0.3,
                child: Container(
                  width: size.width * 0.9,
                  height: size.width * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFE9D3FF).withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -size.height * 0.25,
                right: -size.width * 0.2,
                child: Container(
                  width: size.width * 0.9,
                  height: size.width * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFE9D3FF).withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Center content, spaced to avoid overflow on small screens
              Column(
                children: [
                  SizedBox(height: size.height * 0.18),

                  // App icon with glow and green dot
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(48),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF7F5CFF),
                          Color(0xFFFF5CA8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7F5CFF).withOpacity(0.5),
                          blurRadius: 40,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Color(0xFF7F5CFF),
                              size: 40,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 18,
                          right: 18,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00D26A),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // App name
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Color(0xFF7F5CFF),
                          Color(0xFFFF5CA8),
                        ],
                      ).createShader(bounds);
                    },
                    child: const Text(
                      'Apna Dukan',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Shop your city',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.2,
                    ),
                  ),

                  const Spacer(),

                  // Progress bar + version
                  Column(
                    children: [
                      SizedBox(
                        width: 220,
                        height: 8,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Track
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            // Animated bar that grows from center to both sides
                            AnimatedBuilder(
                              animation: _loaderAnimation,
                              builder: (context, child) {
                                final minFactor = 0.15; // keep a small visible bar
                                final factor = (minFactor + _loaderAnimation.value * (1 - minFactor))
                                    .clamp(0.0, 1.0);
                                final barWidth = 220 * factor;

                                return Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: barWidth,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF7F5CFF),
                                          Color(0xFFFF5CA8),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                    ],
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

