import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/app/routes/app_routes.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_service_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/providers/admin_providers.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/view_model/admin_users_controller.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_error_banner.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_header_card.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_user_form.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/create/create_user_form_result.dart';

class AdminCreateScreen extends ConsumerStatefulWidget {
  const AdminCreateScreen({super.key});

  @override
  ConsumerState<AdminCreateScreen> createState() =>
      _AdminCreateScreenState();
}

class _AdminCreateScreenState
    extends ConsumerState<AdminCreateScreen> {
  String? _error;
  bool _saving = false;

  Future<void> _create(CreateUserFormResult result) async {
    setState(() {
      _error = null;
      _saving = true;
    });

    final usecase = ref.read(createUserUseCaseProvider);

    final res = await usecase(
      fullName: result.fullName,
      email: result.email,
      phone: result.phone,
      role: result.role,
      password: result.password,
      profession: result.profession,
      serviceSlug: result.serviceSlug,
      avatarFile: result.avatarFile,
    );

    if (!mounted) return;

    res.fold(
      (failure) {
        setState(() {
          _error = failure.message ?? 'Create failed';
          _saving = false;
        });
      },
      (_) {
        setState(() {
          _saving = false;
          _error = null;
        });

        // Refresh client + provider lists
        ref.invalidate(adminUsersControllerProvider('client'));
        ref.invalidate(adminUsersControllerProvider('provider'));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully')),
        );

        final normalizedRole = result.role.trim().toLowerCase();
        final targetIndex = normalizedRole == 'provider' ? 2 : 1;

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.adminMain,
          (r) => false,
          arguments: targetIndex,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(adminServicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const CreateHeaderCard(
            title: 'Add New User',
            subtitle:
                'Create a client or a service provider. Avatar is optional. Profession + Service are required for providers.',
          ),
          const SizedBox(height: 14),

          if (_error != null) ...[
            CreateErrorBanner(message: _error!),
            const SizedBox(height: 12),
          ],
          servicesAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => CreateErrorBanner(
              message: e.toString(),
            ),
            data: (List<AdminServiceEntity> services) {
              return CreateUserForm(
                isLoading: _saving,
                onSubmit: _create,
                services: services,
              );
            },
          ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}