import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/core/api/api_client.dart';
import 'package:sajilo_sewa/core/api/api_endpoints.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import '../view_model/provider_profile_controller.dart';
import '../pages/edit_provider_profile_screen.dart';
import '../widgets/profile/provider_profile_header.dart';
import '../widgets/profile/provider_profile_stats_row.dart';
import '../widgets/profile/provider_profile_section_tile.dart';
import '../widgets/profile/Provider_profile_tile.dart';
import '../widgets/profile/provider_profile_tile_switch.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  bool _darkMode = false;
  Future<num>? _earningsFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProviderProfileController>().load();
      _refreshEarnings();
    });
  }

  void _refreshEarnings() {
    setState(() {
      _earningsFuture = _calculateTotalEarnings();
    });
  }

  String _formatWithCommas(num value) {
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final left = s.length - i;
      buf.write(s[i]);
      if (left > 1 && left % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  String? _resolveAvatar(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final u = url.trim();
    if (u.startsWith('http://') || u.startsWith('https://')) return u;
    return "${ApiEndpoints.serverUrl}$u";
  }

  Future<num> _calculateTotalEarnings() async {
    final Dio dio = ApiClient.instance.dio;

    final res = await dio.get(ApiEndpoints.providerBookingsMine(status: "completed"));
    final data = res.data as Map<String, dynamic>;
    final items = (data['items'] ?? data['bookings'] ?? []) as List;

    num total = 0;
    for (final x in items) {
      if (x is Map<String, dynamic>) {
        final status = (x['status'] ?? '').toString();
        final paymentStatus = (x['paymentStatus'] ?? '').toString();
        if (status == 'completed' && paymentStatus == 'paid') {
          final p = x['price'];
          if (p is num) total += p;
          if (p is String) total += num.tryParse(p) ?? 0;
        }
      }
    }
    return total;
  }

  Future<void> _openEdit() async {
    final controller = context.read<ProviderProfileController>();

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: controller,
          child: const EditProviderProfileScreen(),
        ),
      ),
    );

    if (result == true) {
      await context.read<ProviderProfileController>().load();
      _refreshEarnings();
    }
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Logout")),
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
    final c = context.watch<ProviderProfileController>();
    final me = c.me;
    final profile = c.profile;

    final name = c.loading
        ? "Loading..."
        : ((me?.fullName ?? "").trim().isNotEmpty ? me!.fullName : "Provider");

    final email = c.loading ? "" : (me?.email ?? "");
    final phone = c.loading ? "" : (me?.phone ?? "");
    final avatarUrl = _resolveAvatar(me?.avatarUrl);
    final profession = c.loading ? "" : (me?.profession ?? "");

    final bookingsCompleted = (profile?.completedJobs ?? 0).toString();
    final ratingAvg = ((profile?.ratingAvg ?? 0).toDouble()).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            ProviderProfileHeader(
              name: name,
              profession: profession,
              phone: phone,
              email: email,
              avatarUrl: avatarUrl,
              onSettingsTap: _openEdit,
            ),
            if (c.error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Text(
                  c.error!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<ProviderProfileController>().load();
                  _refreshEarnings();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                  child: Column(
                    children: [
                      FutureBuilder<num>(
                        future: _earningsFuture,
                        builder: (context, snap) {
                          final earnings = snap.data ?? 0;
                          final earningsText = "Rs. ${_formatWithCommas(earnings)}";

                          return ProviderProfileStatsRow(
                            bookings: bookingsCompleted,
                            rating: ratingAvg,
                            earnings: earningsText,
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      const ProviderProfileSectionTitle(title: "Account Settings"),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFEFF2FF),
                        icon: Icons.person_outline,
                        iconColor: const Color(0xFF5B4FFF),
                        title: "Edit Profile",
                        onTap: _openEdit,
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
                      const ProviderProfileSectionTitle(title: "Preferences"),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFEAF2FF),
                        icon: Icons.notifications_none,
                        iconColor: const Color(0xFF3B82F6),
                        title: "Notifications",
                        trailingText: "On",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFF5F2FF),
                        icon: Icons.language,
                        iconColor: const Color(0xFF8B5CF6),
                        title: "Language",
                        trailingText: "English",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProviderProfileTileSwitch(
                        iconBg: const Color(0xFFFFF1F1),
                        icon: Icons.dark_mode_outlined,
                        iconColor: const Color(0xFFEF4444),
                        title: "Dark Mode",
                        value: _darkMode,
                        onChanged: (v) => setState(() => _darkMode = v),
                      ),
                      const SizedBox(height: 18),
                      const ProviderProfileSectionTitle(title: "Support & Legal"),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFE8F7FF),
                        icon: Icons.help_outline,
                        iconColor: const Color(0xFF06B6D4),
                        title: "Help Center",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFF2EFFF),
                        icon: Icons.privacy_tip_outlined,
                        iconColor: const Color(0xFF8B5CF6),
                        title: "Privacy Policy",
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      ProviderProfileTile(
                        iconBg: const Color(0xFFEFF6FF),
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF3B82F6),
                        title: "Terms of Service",
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: c.loading ? null : _logout,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFFCA5A5)),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                          ),
                        ),
                      ),
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