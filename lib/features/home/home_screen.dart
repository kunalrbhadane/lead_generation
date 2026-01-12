import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:lead_generation/features/leads/quick_support_request_screen.dart';
import 'package:lead_generation/features/profile/your_profile_screen.dart';
import 'package:lead_generation/features/search/search_screen.dart';
import 'package:lead_generation/features/updates/updates_screen.dart';
import '../../core/theme/app_theme.dart';
import 'providers/category_provider.dart';
import 'models/category_model.dart';
import 'providers/carousel_provider.dart';
import 'models/carousel_model.dart';
import 'providers/daily_update_provider.dart';
import 'models/daily_update_model.dart';
import 'providers/hero_carousel_provider.dart';
import 'models/hero_carousel_model.dart';
import 'package:intl/intl.dart';
import 'daily_update_detail_screen.dart';
import 'package:shimmer/shimmer.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  int _currentTrustIndex = 0;
  int _currentHeroIndex = 0;

  late PageController _pageController; // Using for Trust Carousel
  late PageController _heroPageController;
  Timer? _timer; // Trust Timer
  Timer? _heroTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _heroPageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<DailyUpdateProvider>(context, listen: false).fetchDailyUpdates();
      Provider.of<CarouselProvider>(context, listen: false).fetchCarouselItems();
      Provider.of<HeroCarouselProvider>(context, listen: false).fetchHeroCarousel();
      _startAutoScroll();
      _startHeroAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _heroTimer?.cancel();
    _pageController.dispose();
    _heroPageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (!mounted) return;
      final provider = Provider.of<CarouselProvider>(context, listen: false);
      if (provider.items.isEmpty) return;

      if (_currentTrustIndex < provider.items.length - 1) {
        _currentTrustIndex++;
      } else {
        _currentTrustIndex = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentTrustIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void _startHeroAutoScroll() {
    _heroTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted) return;
      final provider = Provider.of<HeroCarouselProvider>(context, listen: false);
      if (provider.items.isEmpty) return;

      if (_currentHeroIndex < provider.items.length - 1) {
        _currentHeroIndex++;
      } else {
        _currentHeroIndex = 0;
      }

      if (_heroPageController.hasClients) {
        _heroPageController.animateToPage(
          _currentHeroIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
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
                  child: RefreshIndicator(
                    onRefresh: () async {
                      // Fetch both categories and daily updates on pull-to-refresh
                      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
                      final updateProvider = Provider.of<DailyUpdateProvider>(context, listen: false);
                      final carouselProvider = Provider.of<CarouselProvider>(context, listen: false);
                      final heroProvider = Provider.of<HeroCarouselProvider>(context, listen: false);
                      
                      await Future.wait([
                        categoryProvider.fetchCategories(),
                        updateProvider.fetchDailyUpdates(),
                        carouselProvider.fetchCarouselItems(),
                        heroProvider.fetchHeroCarousel(),
                      ]);
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!scrollInfo.metrics.atEdge && scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                           final updateProvider = Provider.of<DailyUpdateProvider>(context, listen: false);
                           if (!updateProvider.isLoading && !updateProvider.isMoreLoading && updateProvider.hasMore) {
                             updateProvider.loadMore();
                           }
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                            // Loading indicator for pagination
                             Consumer<DailyUpdateProvider>(
                               builder: (context, provider, _) {
                                 if (provider.isMoreLoading) {
                                   return const Padding(
                                     padding: EdgeInsets.symmetric(vertical: 20),
                                     child: Center(child: CircularProgressIndicator(color: AppTheme.darkGreen)),
                                   );
                                 }
                                 return const SizedBox.shrink();
                               },
                             ),
                             const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // _buildBottomNavBar removed

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
                return _buildCategorySkeleton();
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
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Know About Trust',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 15),
            _buildTrustCarousel(),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daily Updates',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdatesScreen(initialTabIsVideos: false),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text('View All', style: TextStyle(color: AppTheme.darkGreen, fontWeight: FontWeight.bold)),
                      Icon(Icons.chevron_right, size: 20, color: AppTheme.darkGreen),
                    ],
                  ),
                )
              ],
            ),
            Consumer<DailyUpdateProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return _buildUpdateSkeleton();
                }
                
                if (provider.dailyUpdates.isEmpty) {
                  return const SizedBox.shrink();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.dailyUpdates.length,
                  itemBuilder: (context, index) {
                    final update = provider.dailyUpdates[index];
                    return GestureDetector(
                      onTap: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DailyUpdateDetailScreen(update: update),
                          ),
                        );
                      },
                      child: _buildUpdateItem(
                        update.headline,
                        update.subheadline,
                        update.description,
                        // Format date if needed, assuming API gives ISO string
                        _formatDate(update.createdAt), 
                        _timeAgo(update.createdAt),
                        update.image,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Consumer<HeroCarouselProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
           return Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(48),
                  ),
                ),
             ),
           );
        }

        final items = provider.items;
        
        // Use static banner if no items (fallback)
        if (items.isEmpty) {
           return _buildStaticPromoBanner();
        }

        return Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            ClipPath(
              clipper: _BannerCutoutClipper(),
              child: Container(
                width: double.infinity,
                height: 200, 
                decoration: BoxDecoration(
                  gradient: AppTheme.headerGradient,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: PageView.builder(
                  controller: _heroPageController,
                  itemCount: items.length,
                  onPageChanged: (index) {
                     setState(() {
                       _currentHeroIndex = index;
                     });
                  },
                  itemBuilder: (context, index) {
                    return Image.network(
                      items[index].image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (ctx, _, __) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                      ),
                    );
                  },
                ),
              ),
            ),
             Positioned(
               bottom: -10, // Adjust to fit in the cutout
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 children: List.generate(items.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      width: _currentHeroIndex == index ? 25 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentHeroIndex == index ? AppTheme.lightGreen : const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(_currentHeroIndex == index ? 4 : 50),
                      ),
                    );
                 }),
               ),
             ),
          ],
        );
      },
    );
  }

  Widget _buildStaticPromoBanner() {
    return ClipPath(
      clipper: _BannerCutoutClipper(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 40),
        decoration: BoxDecoration(
          gradient: AppTheme.headerGradient,
          borderRadius: BorderRadius.circular(48),
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



  Widget _buildTrustCarousel() {
    return Consumer<CarouselProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return SizedBox(
            height: 380,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          );
        }

        final items = provider.items.isNotEmpty ? provider.items : [];
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          children: [
            SizedBox(
              height: 380, // Height to fit image + text
              child: PageView.builder(
                controller: _pageController,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentTrustIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  // Mapping CarouselModel to the trust card layout
                  // Image -> image
                  // Heading -> title
                  // Subheading -> subtitle
                  // Description -> body
                  // This maps "Summer Sale" to Title, etc. as requested.
                  return _buildTrustCardItem(
                    item.image,
                    item.heading, 
                    item.subheading,
                    item.description
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(items.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentTrustIndex == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentTrustIndex == index ? AppTheme.lightGreen : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrustCardItem(String imageUrl, String title, String subtitle, String body) {
    bool isNetworkImage = imageUrl.startsWith('http');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5), 
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
            child: isNetworkImage 
              ? Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180, 
                    color: Colors.grey[200], 
                    child: const Icon(Icons.image, size: 50, color: Colors.grey)
                  ),
                )
              : Image.asset(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180, 
                    color: Colors.grey[200], 
                    child: const Icon(Icons.image, size: 50, color: Colors.grey)
                  ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                   children: [
                     const Icon(Icons.circle, size: 10, color: AppTheme.darkGreen),
                     const SizedBox(width: 8),
                     Expanded(
                       child: Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkGreen),
                        overflow: TextOverflow.ellipsis,
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 8),
                 Text(
                   subtitle,
                   style: const TextStyle(fontSize: 13, color: AppTheme.lightGreen, fontWeight: FontWeight.w600),
                 ),
                  const SizedBox(height: 10),
                  Text(
                   body,
                   style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                   maxLines: 4,
                   overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String title, String subheadline, String description, String date, String timeAgo, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9), // Very light green
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              height: 90, // Increased height to accommodate more text
              width: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 90, width: 90, color: Colors.grey.shade300, child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E3B2F)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subheadline.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      subheadline,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.darkGreen),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      description,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: AppTheme.lightGreen),
                        const SizedBox(width: 4),
                        Text(date, style: const TextStyle(fontSize: 11, color: AppTheme.lightGreen, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Text(timeAgo, style: const TextStyle(fontSize: 11, color: AppTheme.lightGreen)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildNavItem(IconData icon, {required bool isSelected}) {
    // Helper functionality moved inline for specific layout control
    return const SizedBox.shrink(); 
  }

  Widget _buildCategorySkeleton() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 15,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpdateSkeleton() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: double.infinity, height: 16, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 150, height: 14, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: double.infinity, height: 12, color: Colors.white),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(width: 80, height: 12, color: Colors.white),
                          Container(width: 60, height: 12, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _timeAgo(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
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


