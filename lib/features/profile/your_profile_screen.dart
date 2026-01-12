import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../updates/updates_screen.dart';
import '../leads/your_leads_screen.dart';
import '../donation/donate_now_screen.dart';
import '../leads/quick_support_request_screen.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'models/user_model.dart';

class YourProfileScreen extends StatefulWidget {
  const YourProfileScreen({super.key});

  @override
  State<YourProfileScreen> createState() => _YourProfileScreenState();
}

class _YourProfileScreenState extends State<YourProfileScreen> {
  bool _isPersonalInfoExpanded = false;
  bool _isDocumentsExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if keyboard is open
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true, // Ensure body resizes when keyboard opens
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
            child: RefreshIndicator(
              onRefresh: () async {
                 await Provider.of<UserProvider>(context, listen: false).fetchUser();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: isKeyboardOpen ? 20 : 120),
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
                  
                  const SizedBox(height: 10),

                   // White Content Area
                   Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100, // Minimal height to look good
                    ),
                    decoration: const BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Consumer<UserProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return _buildProfileSkeleton();
                        }

                        if (provider.errorMessage != null) {
                           return Padding(
                             padding: const EdgeInsets.all(50.0),
                             child: Center(child: Text('Error: ${provider.errorMessage}')),
                           );
                        }

                        final user = provider.user;
                        if (user == null) {
                           return const Padding(
                             padding: EdgeInsets.all(50.0),
                             child: Center(child: Text('User not found')),
                           );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(user.userProfile.isNotEmpty ? user.userProfile : 'https://i.pravatar.cc/300?img=5'),
                                            onBackgroundImageError: (_, __) => const Icon(Icons.person),
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
                                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
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
                                    Text(
                                      user.fullName,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.contactNo,
                                      style: const TextStyle(fontSize: 14, color: AppTheme.textGrey),
                                    ),
                                  ],
                                ),
                              ),
                                 const SizedBox(height: 20),
                              // Menu Options
                              
                              // Personal Information Expandable Tile
                              _buildExpandableInfoTile(user),
                              
                              _buildMenuTile(Icons.person_add_alt_1, "Your Leads", () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => const YourLeadsScreen()),
                                );
                              }),
                              _buildExpandableDocumentsTile(user),
                              _buildMenuTile(Icons.volunteer_activism, "Donate Now", () {
                                 Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => const DonateNowScreen()),
                                );
                              }),
                            ],
                          ),
                        );
                      },
                      ),
            ),
            ],
                   ),
                
              ),
            ),
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

  Widget _buildExpandableInfoTile(UserModel user) {
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
                  _buildTextField(user.fullName),
                  
                  _buildLabel("Contact No"),
                  _buildTextField(user.contactNo, keyboardType: TextInputType.phone),

                  _buildLabel("Gender"),
                  _buildTextField(user.gender), // Defaulted in model if missing

                  _buildLabel("Age"),
                  _buildTextField(user.age > 0 ? user.age.toString() : "", keyboardType: TextInputType.number),

                  _buildLabel("Email"),
                  _buildTextField(user.email, keyboardType: TextInputType.emailAddress),

                  _buildLabel("State"),
                  _buildTextField("Maharashtra"), // Hardcoded for now, or add to model if available

                  _buildLabel("City"),
                  _buildTextField(user.city),

                  _buildLabel("Caste"),
                  _buildTextField(user.caste),

                  _buildLabel("About Description"),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      maxLines: null,
                      controller: TextEditingController(text: user.currentStatus), // Pre-fill with something relevant
                      scrollPadding: const EdgeInsets.only(bottom: 150),
                      decoration: const InputDecoration(
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

  Widget _buildExpandableDocumentsTile(UserModel user) {
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
                _isDocumentsExpanded = !_isDocumentsExpanded;
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppTheme.lightGreenBg, 
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.description, color: AppTheme.darkGreen, size: 20),
            ),
            title: const Text(
              "Documents",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            trailing: Icon(
              _isDocumentsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
              size: 24, 
              color: AppTheme.textGrey
            ),
          ),
          if (_isDocumentsExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  
                  _buildLabel("Current Qualification"),
                  _buildTextField(user.currentQualification),

                  _buildLabel("Field of Study"),
                  _buildTextField(user.fieldOfStudy),

                  _buildLabel("Institute"),
                  _buildTextField(user.institute),

                  _buildLabel("Current Status"),
                  _buildTextField(user.currentStatus),
                  
                  const SizedBox(height: 20),
                  const Text("Uploaded Documents", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),

                  _buildDocumentLink("Adhaar Card", user.adhaarCard),
                  _buildDocumentLink("Income Certificate", user.incomeCertificate),
                  _buildDocumentLink("OBC Certificate", user.obcCertificate),
                  _buildDocumentLink("Marksheets", user.marksheets),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildDocumentLink(String title, String url) {
    if (url.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.grey, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: () => _launchUrl(url),
            child: const Text(
              "View",
              style: TextStyle(color: AppTheme.darkGreen, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch document: $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error launching URL: $e')),
      );
    }
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
        controller: TextEditingController(text: hint), // Set initial value
        keyboardType: keyboardType,
        scrollPadding: const EdgeInsets.only(bottom: 150), // Ensure field scrolls up well above keyboard
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

  Widget _buildProfileSkeleton() {
    return Shimmer.fromColors(
       baseColor: Colors.grey[300]!,
       highlightColor: Colors.grey[100]!,
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
         child: Column(
           children: [
             const SizedBox(height: 30),
             // Avatar Skeleton
             Container(
               width: 100,
               height: 100,
               decoration: const BoxDecoration(
                 color: Colors.white,
                 shape: BoxShape.circle,
               ),
             ),
             const SizedBox(height: 10),
             Container(width: 150, height: 20, color: Colors.white),
             const SizedBox(height: 5),
             Container(width: 100, height: 14, color: Colors.white),
             
             const SizedBox(height: 40),
             
             // Menu Tiles Skeleton
             _buildMenuTileSkeleton(),
             _buildMenuTileSkeleton(),
             _buildMenuTileSkeleton(),
             _buildMenuTileSkeleton(),
           ],
         ),
       ),
    );
  }

  Widget _buildMenuTileSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }


