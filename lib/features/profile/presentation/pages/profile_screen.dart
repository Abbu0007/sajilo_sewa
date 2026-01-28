import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/profile/presentation/view_models/profile_view_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/profile_section_title.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_tile.dart';
import '../widgets/profile_tile_switch.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).loadProfile();
    });
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    await UserSessionService.instance.clearSession();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);
    final profile = state.profile;

    final name = state.isLoading ? "Loading..." : (profile?.fullName ?? "User");
    final email = state.isLoading ? "" : (profile?.email ?? "");
    final phone = state.isLoading ? "" : (profile?.phone ?? "Phone: N/A");

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              name: name,
              phone: phone,
              email: email,
              avatarUrl: profile?.avatarUrl,
              onSettingsTap: () {},
            ),

            if (state.error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Text(
                  state.error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref.read(profileViewModelProvider.notifier).loadProfile(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    children: [
                      const ProfileStatsRow(
                        bookings: "12",
                        favourites: "8",
                        rating: "4.8",
                      ),
                      const SizedBox(height: 18),

                      const ProfileSectionTitle(title: "Account Settings"),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFEFF2FF),
                        icon: Icons.person_outline,
                        iconColor: const Color(0xFF5B4FFF),
                        title: "Edit Profile",
                        onTap: () async {
                          final result = await Navigator.pushNamed(context, AppRoutes.editProfile);
                          if (result == true) {
                            ref.read(profileViewModelProvider.notifier).loadProfile();
                            }
                            },
                      ),

                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFF3ECFF),
                        icon: Icons.location_on_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        title: "Saved Addresses",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFEAFBF2),
                        icon: Icons.credit_card,
                        iconColor: const Color(0xFF22C55E),
                        title: "Payment Methods",
                        onTap: () {},
                      ),

                      const SizedBox(height: 18),
                      const ProfileSectionTitle(title: "Preferences"),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFEAF2FF),
                        icon: Icons.notifications_none,
                        iconColor: const Color(0xFF3B82F6),
                        title: "Notifications",
                        trailingText: "On",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFF5F2FF),
                        icon: Icons.language,
                        iconColor: const Color(0xFF8B5CF6),
                        title: "Language",
                        trailingText: "English",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProfileTileSwitch(
                        iconBg: const Color(0xFFFFF1F1),
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFFEF4444),
                        title: "Dark Mode",
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                      ),

                      const SizedBox(height: 18),
                      const ProfileSectionTitle(title: "Support & Legal"),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFE8F7FF),
                        icon: Icons.help_outline,
                        iconColor: const Color(0xFF06B6D4),
                        title: "Help Center",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFF2EFFF),
                        icon: Icons.privacy_tip_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        title: "Privacy Policy",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFEFF6FF),
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        title: "Terms of Service",
                        onTap: () {},
                      ),

                      const SizedBox(height: 16),
                      ProfileLogoutButton(onTap: _logout),

                      const SizedBox(height: 10),
                      const Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
