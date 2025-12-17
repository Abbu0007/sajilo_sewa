import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/app_colors.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/search_bar.dart';
import 'widgets/quick_categories.dart';
import 'widgets/promo_banner.dart';
import 'widgets/section_header.dart';
import 'widgets/services_grid.dart';
import 'widgets/recent_bookings.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            HomeAppBar(),
            SizedBox(height: 16),

            HomeSearchBar(),
            SizedBox(height: 20),

            QuickCategories(),
            SizedBox(height: 20),

            PromoBanner(),
            SizedBox(height: 24),

            SectionHeader(title: 'All Services', actionText: 'View All'),
            SizedBox(height: 12),

            ServicesGrid(),
            SizedBox(height: 24),

            SectionHeader(title: 'Recent Bookings', actionText: 'View All'),
            SizedBox(height: 12),

            RecentBookings(),
          ],
        ),
      ),
    );
  }
}
