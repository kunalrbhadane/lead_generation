import 'package:flutter/material.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart'; // Import for navigation back if needed, mainly for shared widgets context
import '../profile/profile_screen.dart';
import '../updates/updates_screen.dart';
import '../profile/your_profile_screen.dart';
import '../leads/quick_support_request_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildTopSearchBar(),
                    const SizedBox(height: 20),
                    const Text(
                      'Peoples Near You',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3B2F),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildCategories(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: _buildPeopleList(context),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppTheme.lightGreen, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.black54, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Search From Here',
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            gradient: AppTheme.headerGradient, 
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.tune, color: Colors.white, size: 26),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip('All', Icons.grid_view_rounded, isSelected: false),
          _buildCategoryChip('Students', Icons.school, isSelected: false),
          _buildCategoryChip('Doctors', Icons.medical_services, isSelected: true),
          _buildCategoryChip('Teachers', Icons.people, isSelected: false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, {required bool isSelected}) {
    // Colors based on image:
    // Selected (Doctors): Gradient BG, White content
    // Unselected: Very light green BG, Dark Green content
    final contentColor = isSelected ? Colors.white : AppTheme.darkGreen;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: isSelected ? null : AppTheme.lightGreenBg,
        gradient: isSelected ? AppTheme.headerGradient : null,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: contentColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: contentColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleList(BuildContext context) {
    return ListView(
      children: [
        _buildPersonCard(
          context,
          name: 'Lily wilson',
          role: 'Doctor',
          phone: '8585 555 555',
          location: 'Pune',
          imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
          isFeatured: true, // Gold border
        ),
        _buildPersonCard(
          context,
          name: 'Lily wilson',
          role: 'Doctor',
          phone: '8585 555 555',
          location: 'Pune',
          imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80',
        ),
        _buildPersonCard(
          context,
          name: 'Lily wilson',
          role: 'Doctor',
          phone: '8585 555 555',
          location: 'Pune',
          imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=150&q=80',
        ),
        _buildPersonCard(
          context,
          name: 'Lily wilson',
          role: 'Doctor',
          phone: '8585 555 555',
          location: 'Pune',
          imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
        ),
         _buildPersonCard(
          context,
          name: 'Lily wilson',
          role: 'Doctor',
          phone: '8585 555 555',
          location: 'Pune',
          imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
        ),
      ],
    );
  }

  Widget _buildPersonCard(
    BuildContext context, {
    required String name,
    required String role,
    required String phone,
    required String location,
    required String imageUrl,
    bool isFeatured = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DoctorProfileScreen()),
        );
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Very light grey/white
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: isFeatured ? Border.all(color: const Color(0xFFFBC02D), width: 3) : null, // Gold border
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14), // Inner radius
                  child: Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isFeatured)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Image.asset(
                    'assets/images/medal.png',
                    width: 30,
                    height: 30,
                  ),
                )
            ],
          ),
          const SizedBox(width: 15),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3B2F),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreenBg,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 14, color: AppTheme.darkGreen), // Role Icon
                          const SizedBox(width: 4),
                          Text(
                            role,
                            style: const TextStyle(fontSize: 12, color: AppTheme.darkGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: AppTheme.darkGreen), // WhatsApp/Phone icon green
                    const SizedBox(width: 5),
                    Text(phone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppTheme.darkGreen),
                    const SizedBox(width: 5),
                    Text(location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

    Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12 , 10, 20, 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
                color: const Color(0xFFF1F8E9), 
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  // Home is inactive here
                   GestureDetector(
                     onTap: () {
                       Navigator.pop(context);
                     },
                     child: const Icon(Icons.home, color: AppTheme.darkGreen, size: 26),
                   ),
                   
                   // Search is ACTIVE here
                   Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.headerGradient, 
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.search, color: Colors.white, size: 24),
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
                    child: const Icon(Icons.person_outline, color: AppTheme.darkGreen, size: 26),
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
                 Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
                 SizedBox(width: 8),
                 Text('Need Help ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
               ],
             ),
           )
        ],
      ),
    );
  }
}
