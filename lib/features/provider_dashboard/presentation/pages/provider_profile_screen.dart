import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/datasources/remote/provider_remote_datasource.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/repositories/provider_repository_impl.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_me_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_profile_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/update_provider_profile_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/upload__provider_avatar_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/pages/edit_provider_profile_screen.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/view_model/provider_profile_controller.dart';


class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  late final ProviderProfileController controller;

  @override
  void initState() {
    super.initState();
    final repo = ProviderRepositoryImpl(remote: ProviderRemoteDataSource());
    controller = ProviderProfileController(
      getMe: GetProviderMeUseCase(repo),
      getProfile: GetProviderProfileUseCase(repo),
      updateProfile: UpdateProviderProfileUseCase(repo),
      uploadAvatar: UploadProviderAvatarUseCase(repo),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => controller.load());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UI later — skeleton only
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final name = controller.me?.fullName ?? "Provider";
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.loading) const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text("Profile: $name"),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProviderProfileScreen(controller: controller),
                    ),
                  );
                },
                child: const Text("Edit Profile"),
              ),
            ],
          ),
        );
      },
    );
  }
}