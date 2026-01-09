import 'package:flutter/material.dart';
import 'package:lead_generation/core/theme/app_theme.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    final double headerHeight = 230.0;
    final double profileRadius = 55.0;

    return Scaffold(
      // Ensure body extends behind status bar for transparent look
      extendBodyBehindAppBar: true, 
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header & Profile Image Section ---
            SizedBox(
              height: headerHeight + (profileRadius - 10),
              child: Stack(
                children: [
                  // 1. Gradient Background with Grid
                  Container(
                    height: headerHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.headerGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                      child: CustomPaint(
                        painter: GridPainter(),
                      ),
                    ),
                  ),
                  
                  // 2. Top Navigation Buttons (Now scrollable with header)
                  Positioned(
                    top: 40,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: _buildCircleNavBtn(Icons.arrow_back_ios_new),
                        ),
                        _buildCircleNavBtn(Icons.share_outlined),
                      ],
                    ),
                  ),

                  // 3. Profile Image with Gold Border & Badge
                  Positioned(
                    bottom: 0,
                    left: 20,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.white,
                            border: Border.all(color: AppTheme.gold, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: profileRadius - 4,
                            backgroundImage: const NetworkImage('https://i.pravatar.cc/300?img=5'),
                          ),
                        ),
                        // Badge
                        Positioned(
                          top: -5,
                          right: -5,
                          child: Image.asset(
                            'assets/images/medal.png',
                            width: 35,
                            height: 35,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // --- Doctor Name ---
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                "Dr. Lilly Wilson",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            // --- Tags Row ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTag(
                    text: "Doctor", 
                    icon: Icons.mediation, 
                    bgColor: AppTheme.darkGreen, 
                    contentColor: Colors.white
                  ),
                  const SizedBox(width: 15),
                  _buildTag(
                    text: "Verified", 
                    icon: Icons.verified, 
                    bgColor: const Color(0xFFDCEDC8),
                    contentColor: AppTheme.darkGreen
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // --- Address ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, color: AppTheme.darkGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Golden City Center , Chhatrapati\nSambhajinagar,431001",
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textGrey,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // --- About Card ---
            _buildCardSection(
              title: "About",
              child: Text(
                "General Physician with 15 years experience",
                style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
              ),
            ),

            const SizedBox(height: 6),

            // --- Contact Information Card ---
            _buildCardSection(
              title: "Contact Information",
              child: Column(
                children: [
                  _buildContactRow(Icons.call, "Phone", "+91 2222 222 222"),
                  const SizedBox(height: 10),
                  _buildContactRow(Icons.email, "Email", "lilywilson@gmail.com"),
                ],
              ),
            ),
            
            const SizedBox(height: 15),

            // --- Bottom Buttons (Now Scrollable) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Message Button (Filled)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.darkGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.chat_bubble_outline_rounded, size: 20),
                          SizedBox(width: 8),
                          Text("Message", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Call Now Button (Outlined)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.darkGreen,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppTheme.darkGreen, width: 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.call, size: 20),
                          SizedBox(width: 8),
                          Text("Call Now", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildCardSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildCircleNavBtn(IconData icon) {
    return Container(
      width: 45, height: 45,
      decoration: const BoxDecoration(
        color: AppTheme.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppTheme.textDark, size: 20),
    );
  }

  Widget _buildTag({
    required String text, 
    required IconData icon, 
    required Color bgColor, 
    required Color contentColor
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: contentColor, size: 16),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: contentColor, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFDCEDC8).withOpacity(0.5), // Pale Green
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.darkGreen, size: 24),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: AppTheme.textDark, fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        )
      ],
    );
  }
}

// --- Grid Painter Class ---
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Grid Spacing
    double step = size.width / 5; 

    // Vertical
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    // Horizontal
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}