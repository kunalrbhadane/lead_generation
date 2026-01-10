import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../updates/updates_screen.dart';

class YourProfileScreen extends StatelessWidget {
  const YourProfileScreen({super.key});

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

          // 2. Safe Area Content
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
                            "Your Profile",
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

                const SizedBox(height: 20),

                // White Scrollable Content Area
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120), // Bottom padding for nav bar
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          // Profile Image Section (Overlapping the top edge)
                          Transform.translate(
                            offset: const Offset(0, 0),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Avatar
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppTheme.gold, width: 3),
                                        color: AppTheme.white,
                                      ),
                                      child: const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=5'), // Lily Wilson
                                      ),
                                    ),
                                    
                                    // Medal Badge (Top Right)
                                    Positioned(
                                      top: -5,
                                      right: -5,
                                      child: Image.asset(
                                        'assets/images/medal.png',
                                        width: 35,
                                        height: 35,
                                      ),
                                    ),

                                    // Camera Icon (Bottom Left)
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppTheme.lightGreen, 
                                          shape: BoxShape.circle,
                                          border: Border.fromBorderSide(BorderSide(color: AppTheme.white, width: 2))
                                        ),
                                        child: const Icon(Icons.camera_alt, color: AppTheme.white, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Lily wilson",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "+91 7897 845 745",
                                  style: TextStyle(fontSize: 14, color: AppTheme.textGrey),
                                ),
                              ],
                            ),
                          ),
                             const SizedBox(height: 20),
                          // Menu Options
                          _buildMenuTile(Icons.person, "Personal Information", () {}),
                          _buildMenuTile(Icons.person_add_alt_1, "Your Leads", () {}),
                          _buildMenuTile(Icons.description, "Documents", () {}),
                          _buildMenuTile(Icons.volunteer_activism, "Donate Now", () {}),
                        ],
                      ),
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
            child: _buildBottomNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
           BoxShadow(
             color: Colors.black.withOpacity(0.02),
             blurRadius: 10,
             offset: const Offset(0, 4)
           )
         ]
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.lightGreenBg, // Light green bg for icon
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.darkGreen, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textGrey),
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

                   // Person Active
                   Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.headerGradient, 
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppTheme.white, size: 24),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 10),

          // Right Pill: Need Help
          Container(
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
           )
        ],
      ),
    );
  }
}
