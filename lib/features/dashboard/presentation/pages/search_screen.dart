import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/search/popular_categories.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/search/recent_searches.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/search/search_header.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/search/trending_services.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SearchHeader(),
          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PopularCategories(),
          ),

          SizedBox(height: 24),
          RecentSearches(),

          SizedBox(height: 24),
          TrendingServices(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
