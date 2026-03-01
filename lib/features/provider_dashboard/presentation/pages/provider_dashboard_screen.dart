import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_total_earnings_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/update_provider_me_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/pages/provider_profile_screen.dart';
import '../pages/provider_home_screen.dart';
import '../pages/provider_bookings_screen.dart';
import '../widgets/nav/provider_bottom_nav.dart';
import '../view_model/provider_profile_controller.dart';
import '../../domain/usecases/get_provider_me_usecase.dart';
import '../../domain/usecases/get_provider_profile_usecase.dart';
import '../../domain/usecases/update_provider_profile_usecase.dart';
import '../../domain/usecases/upload__provider_avatar_usecase.dart'; 
import '../../data/repositories/provider_repository_impl.dart';
import '../../data/datasources/remote/provider_remote_datasource.dart';

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
    ProviderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final repo = ProviderRepositoryImpl(
      remote: ProviderRemoteDataSource(),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProviderProfileController(
            getMe: GetProviderMeUseCase(repo),
            getProfile: GetProviderProfileUseCase(repo),
            updateProfile: UpdateProviderProfileUseCase(repo),
            updateMe: UpdateProviderMeUseCase(repo),
            uploadAvatar: UploadProviderAvatarUseCase(repo),
            getTotalEarnings: GetProviderTotalEarningsUseCase(repo)
          ),
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }
}