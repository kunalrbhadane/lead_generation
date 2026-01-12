import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lead_generation/features/home/home_screen.dart';
import 'package:lead_generation/features/leads/quick_support_request_screen.dart';
import 'package:lead_generation/features/profile/your_profile_screen.dart';
import 'package:lead_generation/features/search/search_screen.dart';
import 'package:lead_generation/features/updates/models/video_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../core/theme/app_theme.dart';

import 'package:provider/provider.dart';
import '../updates/providers/video_provider.dart';
import '../../features/home/providers/daily_update_provider.dart';
import '../../features/home/models/daily_update_model.dart';
import '../../features/home/daily_update_detail_screen.dart';
import 'package:intl/intl.dart';


class UpdatesScreen extends StatefulWidget {
  final bool initialTabIsVideos;
  const UpdatesScreen({super.key, this.initialTabIsVideos = true});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  late bool _isVideosTab;

  @override
  void initState() {
    super.initState();
    _isVideosTab = widget.initialTabIsVideos;
    // Fetch videos when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoProvider>(context, listen: false).fetchVideos();
      // Ensure daily updates are fetched if navigating directly or if empty
      if (!_isVideosTab) {
         final updateProvider = Provider.of<DailyUpdateProvider>(context, listen: false);
         if (updateProvider.dailyUpdates.isEmpty) {
           updateProvider.fetchDailyUpdates();
         }
      }
    });
  }
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
       debugPrint('Could not launch $url');
    }
  }

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

                const SizedBox(height: 15),

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
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (_isVideosTab) {
                          await Provider.of<VideoProvider>(context, listen: false).fetchVideos();
                        } else {
                          await Provider.of<DailyUpdateProvider>(context, listen: false).fetchDailyUpdates();
                        }
                      },
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                           if (!_isVideosTab && !scrollInfo.metrics.atEdge && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                             final updateProvider = Provider.of<DailyUpdateProvider>(context, listen: false);
                             if (!updateProvider.isLoading && !updateProvider.isMoreLoading && updateProvider.hasMore) {
                               updateProvider.loadMore();
                             }
                           }
                           return false; // Allow further propagation
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                              const SizedBox(height: 8),
                              
                              if (_isVideosTab) 
                                 Consumer<VideoProvider>(
                                   builder: (context, provider, child) {
                                     if (provider.isLoading) {
                                       return _buildVideoSkeleton();
                                     }
                                     
                                     if (provider.errorMessage != null) {
                                       return Center(child: Padding(
                                         padding: const EdgeInsets.all(20.0),
                                         child: Text('Error: ${provider.errorMessage}'),
                                       ));
                                     }
            
                                     if (provider.videos.isEmpty) {
                                        return const Center(child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text("No videos found."),
                                        ));
                                     }
            
                                     return Column(
                                       children: provider.videos.map((video) => _buildVideoCard(context, video)).toList(),
                                     );
                                   },
                                 )
                               else 
                                 Consumer<DailyUpdateProvider>(
                                   builder: (context, provider, child) {
                                      if (provider.isLoading) {
                                        return const Center(child: CircularProgressIndicator(color: AppTheme.darkGreen));
                                      }
                                      
                                      if (provider.dailyUpdates.isEmpty) {
                                         return const Center(child: Padding(
                                           padding: EdgeInsets.all(20.0),
                                           child: Text("No updates available."),
                                         ));
                                      }

                                      return Column(
                                        children: [
                                          ...provider.dailyUpdates.map((update) => _buildUpdateCard(update)).toList(),
                                          if (provider.isMoreLoading)
                                            const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Center(child: CircularProgressIndicator(color: AppTheme.darkGreen)),
                                            )
                                        ],
                                      );
                                   }
                                 )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(BuildContext context, VideoModel video) {
    return GestureDetector(
      onTap: () {
        if (video.videoUrl.isNotEmpty) {
           _launchUrl(video.videoUrl);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
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
                   Text(video.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                   const SizedBox(height: 4),
                   Text(video.description, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                   const SizedBox(height: 15),
                   // Image / Placeholder for video
                   Stack(
                     alignment: Alignment.center,
                     clipBehavior: Clip.none,
                     children: [
                       ClipPath(
                         clipper: const _CardClipper(holeRadius: 25),
                         child: Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.black12, // Placeholder color
                          child: const Center(child: Icon(Icons.videocam, color: Colors.white, size: 50)),
                          // If we had a thumbnail URL, we would use Image.network here
                          // child: Image.network(video.thumbnailUrl, fit: BoxFit.cover),
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
      ),
    );
  }

  Widget _buildUpdateCard(DailyUpdateModel update) {
    // Format date logic
    String formattedDate = '';
    String timeAgo = '';
    try {
      DateTime dateTime = DateTime.parse(update.createdAt);
      formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
      final difference = DateTime.now().difference(dateTime);
      if (difference.inDays > 0) {
        timeAgo = '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
         timeAgo = '${difference.inHours} hours ago';
      } else {
        timeAgo = '${difference.inMinutes} mins ago';
      }
    } catch (_) {}

    return GestureDetector(
      onTap: () {
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DailyUpdateDetailScreen(update: update),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
            border: Border(
              top: BorderSide(
                color: AppTheme.lightGreen,
                width: 2,
            )),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                update.image,
                height: 90,
                width: 90,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, _) => Container(
                   height: 90, width: 90, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.headline,
                    style: const TextStyle(
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
                      const Icon(Icons.calendar_month, color: AppTheme.lightGreen, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: AppTheme.lightGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const Spacer(),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                           color: AppTheme.lightGreen,
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
      ),
    );
  }

  }

  Widget _buildVideoSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 150, height: 16, color: Colors.white),
                const SizedBox(height: 8),
                Container(width: double.infinity, height: 12, color: Colors.white),
                const SizedBox(height: 15),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
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
