import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/core/providers/theme_provider.dart';
import 'package:sajilo_sewa/core/services/sensors/proximity_hold_service.dart';
import 'package:sajilo_sewa/core/services/sensors/shake_detector_service.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/local/dashboard_local_datasource.dart';
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

class MainBottomNavigationBar extends ConsumerStatefulWidget {
  const MainBottomNavigationBar({super.key});

  @override
  ConsumerState<MainBottomNavigationBar> createState() =>
      _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState
    extends ConsumerState<MainBottomNavigationBar> {
  int _selectedIndex = 0;

  late final DashboardRepositoryImpl repo;
  late final FavouritesController favController;
  late final CreateBookingUseCase createBooking;

  bool _logoutDialogOpen = false;

  @override
  void initState() {
    super.initState();

    repo = DashboardRepositoryImpl(remote: DashboardRemoteDataSource(),local: DashboardLocalDataSourceImpl());

    favController = FavouritesController(
      getFavourites: GetFavouritesUseCase(repo),
      getServices: GetServicesUseCase(repo),
      toggleFavourite: ToggleFavouriteUseCase(repo),
    );

    createBooking = CreateBookingUseCase(repo);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ProximityHoldService.instance.start(
        holdDuration: const Duration(seconds: 5),
        onNearStarted: () {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("Hold for 5 seconds to logout"),
                duration: Duration(seconds: 1),
              ),
            );
        },
        onNearCancelled: () {
          if (!mounted) return;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text("Logout cancelled"),
                duration: Duration(seconds: 1),
              ),
            );
        },
        onHoldCompleted: () async {
          await _showLogoutDialog();
        },
      );

      ShakeDetectorService.instance.start(
        onShake: () {
          if (!mounted) return;

          final current = ref.read(themeProvider);
          final notifier = ref.read(themeProvider.notifier);
          final bool willEnableDark = current != ThemeMode.dark;

          notifier.toggleTheme(willEnableDark);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  willEnableDark
                      ? "Dark mode enabled"
                      : "Light mode enabled",
                ),
                duration: const Duration(milliseconds: 1000),
              ),
            );
        },
        threshold: 18.0,
        requiredShakeCount: 3,
        shakeWindow: const Duration(milliseconds: 900),
        minGap: const Duration(milliseconds: 1800),
      );

      await favController.load();
    });
  }

  Future<void> _showLogoutDialog() async {
    if (!mounted || _logoutDialogOpen) return;

    _logoutDialogOpen = true;

    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you want to logout of account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    _logoutDialogOpen = false;

    if (shouldLogout == true) {
      await _logoutUser();
    }
  }

  Future<void> _logoutUser() async {
    await UserSessionService.instance.clearSession();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  void dispose() {
    favController.dispose();
    ProximityHoldService.instance.stop();
    ShakeDetectorService.instance.stop();
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
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