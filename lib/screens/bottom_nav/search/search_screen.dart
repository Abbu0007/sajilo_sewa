import 'package:flutter/material.dart';
import 'widgets/search_header.dart';
import 'widgets/popular_categories.dart';
import 'widgets/recent_searches.dart';
import 'widgets/trending_services.dart';

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
