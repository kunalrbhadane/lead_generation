import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/home/home_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/updates/updates_screen.dart';
import '../../features/profile/your_profile_screen.dart';
import '../../features/leads/quick_support_request_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 20, 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(38),
          topRight: Radius.circular(38),
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Pill: Navigation Icons
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.lightGreenBg,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavIcon(
                    context,
                    index: 0,
                    icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
                    isSelected: currentIndex == 0,
                  ),
                  _buildNavIcon(
                    context,
                    index: 1,
                    icon: currentIndex == 1 ? Icons.search : Icons.search_outlined,
                    isSelected: currentIndex == 1,
                  ),
                  _buildNavIcon(
                    context,
                    index: 2,
                    icon: currentIndex == 2 ? Icons.play_circle_fill : Icons.play_circle_outline,
                    isSelected: currentIndex == 2,
                  ),
                  _buildNavIcon(
                    context,
                    index: 3,
                    icon: currentIndex == 3 ? Icons.person : Icons.person_outline,
                    isSelected: currentIndex == 3,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Right Pill: Need Help
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QuickSupportRequestScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                gradient: AppTheme.headerGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: const [
                  Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Need Help ?',
                    style: TextStyle(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavIcon(
    BuildContext context, {
    required int index,
    required IconData icon,
    required bool isSelected,
  }) {
    if (isSelected) {
      return Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          gradient: AppTheme.headerGradient,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.white, size: 24),
      );
    } else {
      return GestureDetector(
        onTap: () => onTap(index),
        child: Icon(icon, color: AppTheme.darkGreen, size: 26),
      );
    }
  }
}
