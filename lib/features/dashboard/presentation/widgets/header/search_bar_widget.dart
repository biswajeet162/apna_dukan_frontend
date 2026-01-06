import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

/// Search bar widget for dashboard header
class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onMicPressed;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onMicPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
        vertical: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Find products, brands...',
                  hintStyle: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: MediaQuery.of(context).size.width < 290 ? 12 : 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textGrey,
                    size: MediaQuery.of(context).size.width < 290 ? 18 : 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width < 290 ? 8 : 16,
                    vertical: MediaQuery.of(context).size.width < 290 ? 8 : 12,
                  ),
                ),
              ),
            ),
            if (onMicPressed != null)
              Container(
                margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width < 290 ? 8 : 12,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.mic_none,
                    color: AppColors.textGrey,
                    size: MediaQuery.of(context).size.width < 290 ? 18 : 24,
                  ),
                  onPressed: onMicPressed,
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width < 290 ? 4 : 8,
                  ),
                  constraints: const BoxConstraints(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

