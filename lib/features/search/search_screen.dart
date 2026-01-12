import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart'; 
import '../profile/profile_screen.dart';
import '../updates/updates_screen.dart';
import '../profile/your_profile_screen.dart';
import '../leads/quick_support_request_screen.dart';
import '../home/providers/category_provider.dart';
import '../home/models/category_model.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

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

          ],
        ),
      ),
    );
  }

  Widget _buildCategorySkeleton() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(4, (index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                   Container(width: 20, height: 20, color: Colors.white),
                   const SizedBox(width: 8),
                   Container(width: 60, height: 14, color: Colors.white),
                ],
              ),
            ),
          );
        }),
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
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildCategorySkeleton();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip(
                'All', 
                Icons.grid_view_rounded, 
                isSelected: _selectedCategory == 'All',
                onTap: () => setState(() => _selectedCategory = 'All'),
              ),
              ...provider.categories.map((category) => _buildCategoryItem(
                category,
                isSelected: _selectedCategory == category.name,
                onTap: () => setState(() => _selectedCategory = category.name),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, {required bool isSelected, required VoidCallback onTap}) {
    // Colors based on image:
    // Selected (Doctors): Gradient BG, White content
    // Unselected: Very light green BG, Dark Green content
    // contentColor was not used in original snippet effectively? Re-implementing correctly.
    final contentColor = isSelected ? Colors.white : AppTheme.darkGreen;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category, {required bool isSelected, required VoidCallback onTap}) {
     final contentColor = isSelected ? Colors.white : AppTheme.darkGreen;
     
     return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? null : AppTheme.lightGreenBg,
          gradient: isSelected ? AppTheme.headerGradient : null,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
             ClipOval(
               child: Image.network(
                 category.imageUrl,
                 width: 20, height: 20, fit: BoxFit.cover,
                 errorBuilder: (ctx, err, _) => Icon(Icons.category, color: contentColor, size: 20),
               ),
             ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                color: contentColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
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
    ));
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

}
