import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/core/providers/theme_provider.dart';
import 'package:sajilo_sewa/core/services/sensors/proximity_hold_service.dart';
import 'package:sajilo_sewa/core/services/sensors/shake_detector_service.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/pages/provider_bookings_screen.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/pages/provider_home_screen.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/pages/provider_profile_screen.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/nav/provider_bottom_nav.dart';

class ProviderDashboardScreen extends ConsumerStatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  ConsumerState<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState
    extends ConsumerState<ProviderDashboardScreen> {
  int _index = 0;
  bool _logoutDialogOpen = false;

  final _pages = const [
    ProviderHomeScreen(),
    ProviderBookingsScreen(),
    ProviderProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    ShakeDetectorService.instance.stop();
    ProximityHoldService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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