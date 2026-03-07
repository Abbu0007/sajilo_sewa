import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/core/providers/theme_provider.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/profile_stats_api_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/repositories/profile_repository_impl.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/profile_view_model.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/profile/privacy_policy_content.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/profile/profile_help_content.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/profile/profile_info_sheet.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/profile/profile_terms_content.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/profile/provider_profile_tile.dart';

import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_logout_button.dart';
import '../widgets/profile/profile_section_title.dart';
import '../widgets/profile/profile_stats_row.dart';
import '../widgets/profile/profile_tile.dart';
import '../widgets/profile/profile_tile_switch.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<dynamic>? _statsFuture;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).loadProfile();
      _refreshStats();
    });
  }

  void _refreshStats() {
    final repo = ref.read(profileRepositoryProvider);
    _statsFuture = repo.getClientProfileStats();
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
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final name = state.isLoading ? "Loading..." : (profile?.fullName ?? "User");
    final email = state.isLoading ? "" : (profile?.email ?? "");
    final phone = state.isLoading ? "" : (profile?.phone ?? "Phone: N/A");

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              name: name,
              phone: phone,
              email: email,
              avatarUrl: profile?.avatarUrl,
              onSettingsTap: () async {
                final result =
                    await Navigator.pushNamed(context, AppRoutes.editProfile);
                if (result == true) {
                  await ref.read(profileViewModelProvider.notifier).loadProfile();
                  setState(() {
                    _refreshStats();
                  });
                }
              },
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
                onRefresh: () async {
                  await ref.read(profileViewModelProvider.notifier).loadProfile();
                  setState(() {
                    _refreshStats();
                  });
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: _statsFuture,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const ProfileStatsRow(
                              completedBookings: "…",
                              rating: "…",
                              totalReviews: "…",
                            );
                          }

                          if (!snap.hasData) {
                            return const ProfileStatsRow(
                              completedBookings: "0",
                              rating: "0.0",
                              totalReviews: "0",
                            );
                          }

                          final either = snap.data;
                          return (either as dynamic).fold(
                            (l) => Column(
                              children: [
                                const ProfileStatsRow(
                                  completedBookings: "0",
                                  rating: "0.0",
                                  totalReviews: "0",
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l.message?.toString() ?? "Failed to load stats",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            (ProfileStatsApiModel stats) => ProfileStatsRow(
                              completedBookings:
                                  stats.completedBookings.toString(),
                              rating: stats.ratingAvg.toStringAsFixed(1),
                              totalReviews: stats.ratingCount.toString(),
                            ),
                          );
                        },
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
                          final result =
                              await Navigator.pushNamed(context, AppRoutes.editProfile);
                          if (result == true) {
                            await ref.read(profileViewModelProvider.notifier).loadProfile();
                            setState(() {
                              _refreshStats();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFF3ECFF),
                        icon: Icons.location_on_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        title: "Saved Addresses",
                        trailingText: "Soon",
                        onTap: () {},
                        enabled: false,
                      ),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFEAFBF2),
                        icon: Icons.credit_card,
                        iconColor: const Color(0xFF22C55E),
                        title: "Payment Methods",
                        trailingText: "Soon",
                        onTap: () {},
                        enabled: false,
                      ),
                      const SizedBox(height: 18),
                      const ProfileSectionTitle(title: "Preferences"),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFEAF2FF),
                        icon: Icons.notifications_none,
                        iconColor: const Color(0xFF3B82F6),
                        title: "Notifications",
                        trailingText: "Disabled",
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
                        value: isDark,
                        onChanged: (v) {
                          ref.read(themeProvider.notifier).toggleTheme(v);
                        },
                      ),

                      const SizedBox(height: 18),

                      const ProfileSectionTitle(title: "Support & Legal"),
                      const SizedBox(height: 10),
                      ProfileTile(
                        iconBg: const Color(0xFFE8F7FF),
                        icon: Icons.help_outline,
                        iconColor: const Color(0xFF06B6D4),
                        title: "Help Center",
                        onTap: () {
                          ProfileInfoSheet.show(
                            context,
                            title: "Help Center",
                            content: const HelpCenterContent(),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      ProfileTile(
                          iconBg: const Color(0xFFF2EFFF),
                          icon: Icons.privacy_tip_outlined,
                          iconColor: const Color(0xFF8B5CF6),
                          title: "Privacy Policy",
                          onTap: () {
                            ProfileInfoSheet.show(
                              context,
                              title: "Privacy Policy",
                              content: const PrivacyPolicyContent(),
                            );
                          },
                        ),
                      const SizedBox(height: 10),
                      ProfileTile(
                          iconBg: const Color(0xFFEFF6FF),
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF3B82F6),
                          title: "Terms of Service",
                          onTap: () {
                            ProfileInfoSheet.show(
                              context,
                              title: "Terms of Service",
                              content: const TermsContent(),
                            );
                          },
                      ),
                      const SizedBox(height: 16),
                      ProfileLogoutButton(onTap: _logout),

                      const SizedBox(height: 10),
                      Text(
                        "Version 1.0.0",
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF9CA3AF),
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