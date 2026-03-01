import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/create_booking_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_favourites_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/toggle_favourite_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/bookings_screen.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/favourites_screen.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/home_screen.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/favourites_controller.dart';

class MainBottomNavigationBar extends StatefulWidget {
  const MainBottomNavigationBar({super.key});

  @override
  State<MainBottomNavigationBar> createState() => _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  int _selectedIndex = 0;

  late final DashboardRepositoryImpl repo;
  late final FavouritesController favController;
  late final CreateBookingUseCase createBooking;

  @override
  void initState() {
    super.initState();

    repo = DashboardRepositoryImpl(remote: DashboardRemoteDataSource());

    favController = FavouritesController(
      getFavourites: GetFavouritesUseCase(repo),
      getServices: GetServicesUseCase(repo),
      toggleFavourite: ToggleFavouriteUseCase(repo),
    );

    createBooking = CreateBookingUseCase(repo);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await favController.load(); 
    });
  }

  @override
  void dispose() {
    favController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        repo: repo,
        favController: favController,
        createBooking: createBooking,
      ),
      const BookingsScreen(),
      FavouritesScreen(
        favController: favController,
        createBooking: createBooking,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}