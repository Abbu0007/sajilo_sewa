import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/view_model/admin_bookings_controller.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/bookings/admin_booking_card.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/bookings/admin_bookings_header_card.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/widgets/bookings/admin_booking_details_sheet.dart';

class AdminBookingsScreen extends ConsumerStatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  ConsumerState<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends ConsumerState<AdminBookingsScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
        ref.read(adminBookingsControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminBookingsControllerProvider);
    final notifier = ref.read(adminBookingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => notifier.loadFirst(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.loadFirst(),
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          children: [
            AdminBookingsHeaderCard(
              status: state.status,
              queryController: _search,
              total: state.total,
              showing: state.items.length,
              onStatusChanged: notifier.setStatus,
              onSearch: () => notifier.setQuery(_search.text),
              onClear: () {
                _search.clear();
                notifier.setQuery('');
              },
            ),
            const SizedBox(height: 12),

            if (state.loading)
              const Padding(
                padding: EdgeInsets.all(22),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null)
              _ErrorBox(
                message: state.error!,
                onRetry: notifier.loadFirst,
              )
            else if (state.items.isEmpty)
              const _EmptyBox()
            else
              ...state.items.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AdminBookingCard(
                    booking: b,
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                        builder: (_) => AdminBookingDetailsSheet(
                          booking: b,
                          onCancel: (reason) async {
                            final err = await notifier.adminCancel(b.id, reason);
                            if (!context.mounted) return;
                            if (err != null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                              return;
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Booking cancelled')),
                            );
                          },
                          onDelete: () async {
                            final ok = await _confirmDelete(context);
                            if (!ok) return;
                            final err = await notifier.adminDelete(b.id);
                            if (!context.mounted) return;
                            if (err != null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                              return;
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Booking deleted')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

            if (state.loadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete booking?'),
            content: const Text('This will permanently remove the booking from the database.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
            ],
          ),
        )) ??
        false;
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('No bookings found', style: TextStyle(fontWeight: FontWeight.w900)),
          SizedBox(height: 6),
          Text('Try changing status or searching with another keyword.'),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFFFEBEE),
        border: Border.all(color: const Color(0xFFEF9A9A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Failed to load', style: TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}