import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_app_bar.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/promo_banner.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/quick_categories.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/recent_bookings.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/search_bar.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/section_header.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/services_grid.dart';

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
