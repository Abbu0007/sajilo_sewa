import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/profile_screen.dart';
import '../pages/provider_home_screen.dart';
import '../pages/provider_bookings_screen.dart';
import '../widgets/nav/provider_bottom_nav.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() => _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  int _index = 0;

  final _pages = const [
    ProviderHomeScreen(),
    ProviderBookingsScreen(), 
    ProfileScreen(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: _pages,
        ),
      ),
      bottomNavigationBar: ProviderBottomNav(
        currentIndex: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}