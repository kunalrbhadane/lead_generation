import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../updates/updates_screen.dart';
import '../leads/your_leads_screen.dart';
import '../donation/donate_now_screen.dart';
import '../leads/quick_support_request_screen.dart';

class YourProfileScreen extends StatefulWidget {
  const YourProfileScreen({super.key});

  @override
  State<YourProfileScreen> createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends State<YourProfileScreen> {
  bool _isPersonalInfoExpanded = false;

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
                          const SizedBox(height: 30),
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
                          
                          // Personal Information Expandable Tile
                          _buildExpandableInfoTile(),
                          
                          _buildMenuTile(Icons.person_add_alt_1, "Your Leads", () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const YourLeadsScreen()),
                            );
                          }),
                          _buildMenuTile(Icons.description, "Documents", () {}),
                          _buildMenuTile(Icons.volunteer_activism, "Donate Now", () {
                             Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const DonateNowScreen()),
                            );
                          }),
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
            child: const CustomBottomNavBar(currentIndex: 3),
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
          decoration: const BoxDecoration(
            color: AppTheme.lightGreenBg, 
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

  Widget _buildExpandableInfoTile() {
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
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _isPersonalInfoExpanded = !_isPersonalInfoExpanded;
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppTheme.lightGreenBg, 
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppTheme.darkGreen, size: 20),
            ),
            title: const Text(
              "Personal Information",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            trailing: Icon(
              _isPersonalInfoExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
              size: 24, 
              color: AppTheme.textGrey
            ),
          ),
          if (_isPersonalInfoExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  _buildLabel("Full Name"),
                  _buildTextField("Lily wilson"),
                  
                  _buildLabel("Contact No"),
                  _buildTextField("8547455141", keyboardType: TextInputType.phone),

                  _buildLabel("Gender"),
                  _buildTextField("Female"),

                  _buildLabel("Age"),
                  _buildTextField("21", keyboardType: TextInputType.number),

                  _buildLabel("Whatsapp contact no"),
                  _buildTextField("8574857485", keyboardType: TextInputType.phone),

                  _buildLabel("State"),
                  _buildTextField("Maharashtra"),

                  _buildLabel("City"),
                  _buildTextField("Sambhajinagar"),

                  _buildLabel("Caste"),
                  _buildTextField("OBC"),

                  _buildLabel("About Description"),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter about yourself",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Save Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppTheme.headerGradient,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.darkGreen.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ]
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                         setState(() {
                           _isPersonalInfoExpanded = false; // Collapse after save
                         });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Save Changes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, 
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(
             color: Color(0xFF4B4B4B), // Dark Grey
             fontSize: 14,
             fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {TextInputType? keyboardType}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFcfcfc), // Slightly off-white
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black87, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
