import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/pages/admin_clients_screen.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/view_model/admin_users_controller.dart';

import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/admin_user_edit_form.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/admin_user_view_card.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/clients_header_card.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/clients_search_field.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/clients_stat_pill.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/client_user_card.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/clients_empty_state.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/clients%20and%20providers/clients_error_state.dart';

class AdminProvidersScreen extends ConsumerStatefulWidget {
  const AdminProvidersScreen({super.key});

  @override
  ConsumerState<AdminProvidersScreen> createState() => _AdminProvidersScreenState();
}

class _AdminProvidersScreenState extends ConsumerState<AdminProvidersScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersControllerProvider('provider'));
    final notifier = ref.read(adminUsersControllerProvider('provider').notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Providers'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => notifier.refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ClientsErrorState(
          message: e.toString(),
          onRetry: () => notifier.load(),
        ),
        data: (users) {
          final providers = users
              .where((u) => u.role.trim().toLowerCase() == 'provider')
              .toList();

          final q = _search.text.trim().toLowerCase();
          final visible = q.isEmpty
              ? providers
              : providers.where((u) {
                  return u.fullName.toLowerCase().contains(q) ||
                      u.email.toLowerCase().contains(q) ||
                      u.phone.toLowerCase().contains(q) ||
                      (u.profession ?? '').toLowerCase().contains(q);
                }).toList();

          return RefreshIndicator(
            onRefresh: () => notifier.refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                ClientsHeaderCard(
                  title: 'Manage Service Providers',
                  subtitle: 'View details, edit, or remove providers.',
                  count: providers.length,
                ),
                const SizedBox(height: 12),
                ClientsSearchField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  onClear: () {
                    _search.clear();
                    setState(() {});
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ClientsStatPill(
                      label: 'Total: ${providers.length}',
                      icon: Icons.engineering_outlined,
                    ),
                    const SizedBox(width: 8),
                    ClientsStatPill(
                      label: 'Showing: ${visible.length}',
                      icon: Icons.filter_alt_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (providers.isEmpty)
                  const ClientsEmptyState(
                    title: 'No providers found',
                    subtitle: 'Once providers exist in the database, they will appear here.',
                  )
                else if (visible.isEmpty)
                  const ClientsEmptyState(
                    title: 'No results',
                    subtitle: 'Try a different name, email, phone, or profession.',
                  )
                else
                  ...visible.map(
                    (u) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ClientUserCard(
                        user: u,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminUserViewScreen(user: u),
                              ),
                          );
                        },
                    onMore: () => _openActionsSheet(context, u),
                    ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openActionsSheet(BuildContext context, AdminUserEntity user) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: (user.avatarUrl ?? '').trim().isNotEmpty
                        ? NetworkImage(user.avatarUrl!.trim())
                        : null,
                    child: (user.avatarUrl ?? '').trim().isNotEmpty
                        ? null
                        : Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(user.email, style: TextStyle(color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: const Text('View details', style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminProviderViewScreen(user: user),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit user', style: TextStyle(fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminProviderEditScreen(user: user),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete user',
                  style: TextStyle(fontWeight: FontWeight.w700, color: Colors.red),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final ok = await _confirmDelete(context, user.fullName);
                  if (!ok) return;

                  final err = await ref
                      .read(adminUsersControllerProvider('provider').notifier)
                      .removeUser(user.id);

                  if (!mounted) return;

                  if (err != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Deleted successfully')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    return (await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete user?'),
            content: Text('Are you sure you want to delete $name from the database?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class AdminProviderViewScreen extends StatelessWidget {
  final AdminUserEntity user;
  const AdminProviderViewScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AdminUserViewCard(
          user: user,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AdminProviderEditScreen(user: user),
              ),
            );
          },
          onDelete: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Delete from list screen')),
            );
          },
        ),
      ),
    );
  }
}

class AdminProviderEditScreen extends ConsumerWidget {
  final AdminUserEntity user;
  const AdminProviderEditScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminUsersControllerProvider('provider').notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Provider')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AdminUserEditForm(
          user: user,
          onSave: (result) async {
            final err = await notifier.editUser(
              userId: user.id,
              fullName: result.fullName,
              phone: user.phone,
              role: user.role,
              profession: user.profession,
              avatarFile: result.pickedAvatar,
            );

            if (!context.mounted) return;

            if (err != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
              return;
            }

            await notifier.refresh();

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Saved successfully')),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
