import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/search_bar.dart';
import 'widgets/categories_list.dart';
import 'widgets/promo_banner.dart';
import 'widgets/all_services_header.dart';
import 'widgets/services_grid.dart';
import 'widgets/recent_bookings_header.dart';
import 'widgets/bookings_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Header(),
              const SizedBox(height: 10),
              const SearchBarWidget(),
              const CategoriesList(),
              const PromoBanner(),
              const AllServicesHeader(),
              const ServicesGrid(),
              const RecentBookingsHeader(),
              const BookingsList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
