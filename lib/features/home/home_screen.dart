import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lead_generation/features/leads/quick_support_request_screen.dart';
import 'package:lead_generation/features/profile/your_profile_screen.dart';
import 'package:lead_generation/features/search/search_screen.dart';
import 'package:lead_generation/features/updates/updates_screen.dart';
import '../../core/theme/app_theme.dart';
import 'providers/category_provider.dart';
import 'models/category_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      extendBodyBehindAppBar: true, 
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: 600, 
            decoration: const BoxDecoration(
              gradient: AppTheme.headerGradient,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 27),
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildSearchBar(context),
                        const SizedBox(height: 25),
                        _buildCategories(),
                        const SizedBox(height: 20),
                        _buildBodyContent(),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavBar(context), // Docked at the bottom of the SafeArea/Column
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hello Nik !!!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'What you would like to do today ?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54, size: 28),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Search From Here',
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient, 
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Browse By Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 65, // Fixed height for the scrolling list
          child: Consumer<CategoryProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: CircularProgressIndicator(color: Colors.white),
                ));
              }
              
              // Combine "All" with fetched categories
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 1 + provider.categories.length, // 1 for "All"
                itemBuilder: (context, index) {
                  if (index == 0) {
                     return _buildCategoryChip(
                       'All', 
                       Icons.grid_view_rounded, 
                       isSelected: _selectedCategory == 'All',
                       onTap: () => setState(() => _selectedCategory = 'All')
                     );
                  }
                  
                  final category = provider.categories[index - 1];
                  return _buildCategoryItem(
                    category, 
                    isSelected: _selectedCategory == category.name,
                    onTap: () => setState(() => _selectedCategory = category.name)
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: isSelected ? Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(4), 
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjusted vertical padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.darkGreen, size: 30),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ) : Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.lightGreen.withOpacity(0.4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryModel category, {required bool isSelected, required VoidCallback onTap}) {
    // For dynamic categories, we might want to use the image URL if available, 
    // but for now we'll stick to the chip style using a default icon or ignoring the image for consistency with the design provided.
    // If the image is crucial, we can update this. The API returns an Image URL (png).
    
    // Let's use the Image URL if it's valid, otherwise a default icon.
    // Since the design is pill-shaped chips, images might look small.
    
    return GestureDetector(
      onTap: onTap,
      child: isSelected ? Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(4), 
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              // Display small image
               ClipOval(
                 child: Image.network(
                   category.imageUrl,
                   width: 35, height: 35, fit: BoxFit.cover,
                   errorBuilder: (ctx, err, _) => const Icon(Icons.category, color: AppTheme.darkGreen, size: 35),
                 ),
               ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(
                  color: AppTheme.darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ) : Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.lightGreen.withOpacity(0.4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
             ClipOval(
                 child: Image.network(
                   category.imageUrl,
                   width: 35, height: 35, fit: BoxFit.cover,
                   errorBuilder: (ctx, err, _) => const Icon(Icons.category, color: Colors.white, size: 35),
                 ),
               ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBodyContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                _buildPromoBanner(),
                 Positioned(
                   bottom: -10, // Adjust to fit in the cutout
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle)),
                       const SizedBox(width: 5),
                       Container(width: 25, height: 8, decoration: BoxDecoration(color: AppTheme.lightGreen, borderRadius: BorderRadius.circular(4))),
                       const SizedBox(width: 5),
                       Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFE0E0E0), shape: BoxShape.circle)),
                     ],
                   ),
                 )
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Know About Trust',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),
            _buildTrustCard(),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Updates',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text('View All', style: TextStyle(color: AppTheme.darkGreen, fontWeight: FontWeight.bold)),
                      Icon(Icons.chevron_right, size: 20, color: AppTheme.darkGreen),
                    ],
                  ),
                )
              ],
            ),
            _buildUpdateItem(
              'Scholarship Applications Now Open',
              '12 June 2025',
              '2 hours ago',
              'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=100&q=80',
            ),
            _buildUpdateItem(
              'Free Legal Consultation Available',
              '12 June 2025',
              '2 hours ago',
              'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?auto=format&fit=crop&w=100&q=80',
            ),
             _buildUpdateItem(
              'Job Fair - Multiple Openings',
              '12 June 2025',
              '3 hours ago',
              'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=100&q=80',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return ClipPath(
      clipper: _BannerCutoutClipper(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 40),
        decoration: BoxDecoration(
          gradient: AppTheme.headerGradient,
          borderRadius: BorderRadius.circular(48), // Increased radius
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Educational',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'New Education Support Program Launched',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Transform.scale(
                scale: 1.2,
                child: Image.network(
                  'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=300&q=80',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.darkGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            child: Image.network(
              'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=500&q=80',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                   children: const [
                     Icon(Icons.circle, size: 10, color: AppTheme.darkGreen),
                     SizedBox(width: 8),
                     Text(
                      'Transparent Support Process',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkGreen),
                     ),
                   ],
                 ),
                 const SizedBox(height: 8),
                 const Text(
                   'No hidden steps. No confusion.',
                   style: TextStyle(fontSize: 14, color: AppTheme.lightGreen, fontWeight: FontWeight.w500),
                 ),
                  const SizedBox(height: 12),
                  const Text(
                   'Every support request follows a clear and transparent process from submission to review and resolution...',
                   style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String title, String date, String timeAgo, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9), // Very light green
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2E3B2F)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: AppTheme.lightGreen),
                        const SizedBox(width: 5),
                        Text(date, style: const TextStyle(fontSize: 12, color: AppTheme.lightGreen, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Text(timeAgo, style: const TextStyle(fontSize: 12, color: AppTheme.lightGreen)),
                  ],
                ),
              ],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed to spaceAround for more inter-icon spacing
                children: [
                   Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.headerGradient, 
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.home, color: Colors.white, size: 24),
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
                    child: const Icon(Icons.person_outline, color: AppTheme.darkGreen, size: 26),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 10), // Reduced gap to 10

          // Right Pill: Need Help
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const QuickSupportRequestScreen()),
              );
            },
            child: Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Reduced horizontal padding to 16
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
             ),
          )
        ],
      ),
    );
  }

}

class _BannerCutoutClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double radius = 48.0; // Increased radius to match container
    const double notchWidth = 100.0; // Total width of the cutout area
    const double notchDepth = 15.0;  // How deep the cutout goes into the card

    // Top and Side edges (Standard rounded rectangle)
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);

    // Bottom Edge and Cutout
    final double centerX = size.width / 2;
    final double cutoutStart = centerX - (notchWidth / 2);
    final double cutoutEnd = centerX + (notchWidth / 2);

    // Line to start of cutout curve
    path.lineTo(cutoutEnd, size.height);

    // The Cutout (Smoother "inverted pill" shape)
    // We use cubicTo for smooth S-curves entering and exiting the notch
    path.cubicTo(
      cutoutEnd - 10, size.height, // Control point 1 (start smoothing)
      cutoutEnd - 10, size.height - notchDepth, // Control point 2 (approaching depth)
      centerX + 15, size.height - notchDepth, // End of first curve (near center)
    );
    
    // Flat top (middle of notch)
    path.lineTo(centerX - 15, size.height - notchDepth);

    // Exit curve
    path.cubicTo(
      cutoutStart + 10, size.height - notchDepth, // Control point 1 (leaving depth)
      cutoutStart + 10, size.height, // Control point 2 (approaching bottom)
      cutoutStart, size.height, // End point
    );

    // Finish bottom edge
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}


