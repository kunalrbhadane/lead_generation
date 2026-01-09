import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../profile/your_profile_screen.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  bool _isVideosTab = true; // State to track active tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Updates & Videos",
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

                // Custom Tab Toggle (Videos / Updates)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Videos Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isVideosTab = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isVideosTab ? Colors.white : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: _isVideosTab ? null : Border.all(color: Colors.white),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_fill, 
                                  color: _isVideosTab ? AppTheme.darkGreen : Colors.white, 
                                  size: 22
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Videos", 
                                  style: TextStyle(
                                    color: _isVideosTab ? AppTheme.darkGreen : Colors.white, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Updates Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isVideosTab = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isVideosTab ? Colors.white : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: !_isVideosTab ? null : Border.all(color: Colors.white),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.article, 
                                  color: !_isVideosTab ? AppTheme.darkGreen : Colors.white, 
                                  size: 22
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Updates", 
                                  style: TextStyle(
                                    color: !_isVideosTab ? AppTheme.darkGreen : Colors.white, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // White Scrollable Content Area
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 120), // Bottom padding for nav bar
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isVideosTab ? "See All Videos" : "See all Updates From Below",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          if (_isVideosTab) ...[
                            _buildVideoCard(context),
                            _buildVideoCard(context),
                            _buildVideoCard(context),
                          ] else ...[
                            _buildUpdateCard(),
                            _buildUpdateCard(),
                            _buildUpdateCard(),
                            _buildUpdateCard(),
                          ]
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

  Widget _buildVideoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Main Content Card
          Container(
             margin: const EdgeInsets.only(top: 10), // Space for overlap
             padding: const EdgeInsets.all(15),
             decoration: BoxDecoration(
               color: const Color(0xFFF9F9F9),
               borderRadius: BorderRadius.circular(25),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Text("Success Story", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                 const SizedBox(height: 4),
                 const Text("From Farmer to Entrepreneur", style: TextStyle(color: Colors.grey, fontSize: 13)),
                 const SizedBox(height: 15),
                 // Image
                 Stack(
                   alignment: Alignment.center,
                   clipBehavior: Clip.none,
                   children: [
                     ClipPath(
                       clipper: const _CardClipper(holeRadius: 25),
                       child: Image.asset(
                         'assets/images/video_thumbnail.png', 
                         height: 180,
                         width: double.infinity,
                         fit: BoxFit.cover,
                       ),
                     ),
                     Container(
                        height: 50, width: 50,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow_rounded, color: AppTheme.lightGreen, size: 35),
                     ),
                     // Heart Icon (Positioned in the cutout)
                     Positioned(
                        right: -3,
                        top: -3,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.darkGreen, 
                            shape: BoxShape.circle,
                            border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 3)) 
                          ),
                          child: const Icon(Icons.favorite, color: Colors.white, size: 25),
                        ),
                      ),
                   ],
                 )
               ],
             )
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.lightGreen, width: 1),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=300&q=80',
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Scholarship Applications Now Open",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, color: AppTheme.darkGreen, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      "12 June 2025",
                      style: TextStyle(
                        color: AppTheme.darkGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "2 hours ago",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
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

                   // Play Active
                   Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.headerGradient, 
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 24),
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

// Custom Clipper for the Top-Right Cutout
class _CardClipper extends CustomClipper<Path> {
  final double holeRadius;

  const _CardClipper({required this.holeRadius});

  @override
  Path getClip(Size size) {
    final double radius = 20.0; // Corner radius
    Path path = Path();
    
    // Start Top Left
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // 1. Top Edge to near corner
    path.lineTo(size.width - holeRadius, 0); 
    
    // 2. Concave cutout
    // Arc from (w-R, 0) to (w, R) going INWARD (concave)
    path.arcToPoint(
      Offset(size.width, holeRadius),
      radius: Radius.circular(holeRadius),
      clockwise: false, 
    );

    // 3. Right Edge down
    path.lineTo(size.width, size.height - radius);
    
    // 4. Bottom Right
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
    
    // 5. Bottom Left
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    
    path.close();
    return path;
    
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
