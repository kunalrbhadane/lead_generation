import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../updates/updates_screen.dart';
import '../profile/your_profile_screen.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import 'quick_support_request_screen.dart';

class YourLeadsScreen extends StatefulWidget {
  const YourLeadsScreen({super.key});

  @override
  State<YourLeadsScreen> createState() => _YourLeadsScreenState();
}

class _YourLeadsScreenState extends State<YourLeadsScreen> {
  String _selectedTab = 'All'; // 'All', 'Pending', 'Approved'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          // 1. Green Gradient Background (Top Half)
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: AppTheme.headerGradient,
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // Header (Back + Title)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: AppTheme.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.textDark),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Your Support Requests",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Balance Back Button
                    ],
                  ),
                ),

                // Filter Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFilterTab("All"),
                      _buildFilterTab("Pending"),
                      _buildFilterTab("Approved"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Content Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 120),
                          child: Column(
                            children: [
                              _buildRequestCard(),
                              // Add more items here dynamically based on _selectedTab
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: const CustomBottomNavBar(currentIndex: 3),
          ),
          
          // 4. Floating Action Button
          Positioned(
            bottom: 90, 
            left: 0, 
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const QuickSupportRequestScreen()),
                    );
                },
                child: Container(
                  height: 60, width: 60,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.headerGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4)
                      )
                    ]
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title) {
    bool isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          border: isSelected ? Border.all(color: AppTheme.white, width: 2) :Border.all(color: AppTheme.white.withOpacity(0.0), width: 0),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppTheme.darkGreen : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppTheme.darkGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 24),
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE0B2), // Light Orange
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Pending",
                  style: TextStyle(
                    color: Color(0xFFF57C00),
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Educational Support Request",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Requesting scholarship for engineering studies",
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textGrey,
              height: 1.4
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildChip(Icons.calendar_month, "2 Days Ago"),
              const SizedBox(width: 10),
              _buildChip(Icons.school_outlined, "Education"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.lightGreenBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.lightGreen.withOpacity(0.5))
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.darkGreen),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.darkGreen,
              fontWeight: FontWeight.w600,
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12 , 10, 20, 12),
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
                   GestureDetector(
                     onTap: () {
                         Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false
                        );
                     },
                     child: const Icon(Icons.home_outlined, color: AppTheme.darkGreen, size: 26),
                   ),
                   GestureDetector(
                     onTap: () {
                       Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const SearchScreen()),
                        );
                     },
                     child: const Icon(Icons.search, color: AppTheme.darkGreen, size: 26),
                   ),
                   GestureDetector(
                    onTap: () {
                       Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const UpdatesScreen()),
                        );
                     },
                    child: const Icon(Icons.play_circle_outline, color: AppTheme.darkGreen, size: 26),
                   ),
                   GestureDetector(
                    onTap: () {
                       Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const YourProfileScreen()),
                        );
                     },
                    // Still show active person icon as we are technically within the profile section flow
                    child: const Icon(Icons.person, color: AppTheme.darkGreen, size: 26),
                   ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
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
                   Text('Need Help ?', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold, fontSize: 15)),
                 ],
               ),
             ),
          )
        ],
      ),
    );
  }
}
