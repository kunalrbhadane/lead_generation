import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'models/daily_update_model.dart';
import 'package:intl/intl.dart';

class DailyUpdateDetailScreen extends StatelessWidget {
  final DailyUpdateModel update;

  const DailyUpdateDetailScreen({super.key, required this.update});

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.darkGreen,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppTheme.textDark),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                update.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    update.headline,
                    style: const TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: AppTheme.textDark,
                      height: 1.2
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppTheme.lightGreen),
                      const SizedBox(width: 6),
                      Text(
                        _formatDate(update.createdAt),
                        style: const TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w500, 
                          color: AppTheme.lightGreen
                        ),
                      ),
                    ],
                  ),
                  if (update.subheadline.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      update.subheadline,
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w600, 
                        color: AppTheme.darkGreen
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Text(
                    update.description,
                    style: const TextStyle(
                      fontSize: 16, 
                      color: Colors.black87, 
                      height: 1.6
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
