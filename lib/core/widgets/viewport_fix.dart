import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Widget that fixes viewport height issues on Flutter Web mobile browsers
/// when the virtual keyboard opens and closes
class ViewportFix extends StatefulWidget {
  final Widget child;

  const ViewportFix({
    super.key,
    required this.child,
  });

  @override
  State<ViewportFix> createState() => _ViewportFixState();
}

class _ViewportFixState extends State<ViewportFix> {
  double? _lastViewportHeight;
  bool _isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return widget.child;
    }

    final mediaQuery = MediaQuery.of(context);
    final currentHeight = mediaQuery.size.height;
    final viewInsets = mediaQuery.viewInsets;
    final keyboardHeight = viewInsets.bottom;

    // Detect keyboard state
    final wasKeyboardVisible = _isKeyboardVisible;
    _isKeyboardVisible = keyboardHeight > 0;

    // If keyboard was just dismissed, force multiple rebuilds
    if (wasKeyboardVisible && !_isKeyboardVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Force immediate rebuild
          setState(() {});
          
          // Schedule additional frame
          WidgetsBinding.instance.scheduleFrame();
          
          // Delayed rebuilds to ensure layout settles
          Future.delayed(const Duration(milliseconds: 50), () {
            if (mounted) {
              setState(() {});
            }
          });
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted) {
              setState(() {});
            }
          });
        }
      });
    }

    // Update last known height and detect significant height increases
    if (_lastViewportHeight != null && 
        currentHeight > _lastViewportHeight! + 50) {
      // Height increased significantly, likely keyboard dismissed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
    _lastViewportHeight = currentHeight;

    // Wrap child with a LayoutBuilder to force layout recalculation
    // Use MediaQuery to get the actual viewport size
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the actual screen height from MediaQuery
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        
        // Use the maximum available height
        final maxHeight = constraints.maxHeight > 0 && constraints.maxHeight < screenHeight
            ? screenHeight
            : (constraints.maxHeight > 0 ? constraints.maxHeight : screenHeight);
        
        // Force full height container
        return SizedBox(
          height: maxHeight,
          width: constraints.maxWidth > 0 ? constraints.maxWidth : screenWidth,
          child: widget.child,
        );
      },
    );
  }
}

