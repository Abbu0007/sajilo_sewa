import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_clients_screen.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_create_screen.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_providers_screen.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_home_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  void _goToTab(int index) {
    if (index < 0 || index > 4) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      AdminHomeScreen(onNavigateTab: _goToTab),
      const AdminClientsScreen(),
      const AdminProvidersScreen(),
      const AdminCreateScreen(),
      const _AdminBookingsPlaceholder(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _goToTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            activeIcon: Icon(Icons.handyman),
            label: 'Providers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1_outlined),
            activeIcon: Icon(Icons.person_add_alt_1),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
        ],
      ),
    );
  }
}

class _AdminBookingsPlaceholder extends StatelessWidget {
  const _AdminBookingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Bookings UI-only (Next)',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
