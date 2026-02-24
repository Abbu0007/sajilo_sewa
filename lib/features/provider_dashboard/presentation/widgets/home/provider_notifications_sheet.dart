import 'package:flutter/material.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_notification_entity.dart';
import '../../view_model/provider_notifications_controller.dart';

class ProviderNotificationsSheet extends StatelessWidget {
  final ProviderNotificationsController controller;

  
  final Future<void> Function(ProviderNotificationEntity n)? onTapNotification;

  const ProviderNotificationsSheet({
    super.key,
    required this.controller,
    this.onTapNotification,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 5,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Notifications",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                if (controller.loading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (controller.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFFFEF2F2),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            controller.error!,
                            style: const TextStyle(
                              color: Color(0xFF991B1B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: controller.load,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                else if (controller.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Text(
                      "No notifications at the moment",
                      style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w700),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final n = controller.items[i];
                        return InkWell(
                          onTap: () async {
                            // mark read first (like you already do)
                            if (!n.isRead) {
                              await controller.markAsReadAndRefresh(n.id);
                            }

                            // ✅ then run custom action (rating popup etc.)
                            if (onTapNotification != null) {
                              await onTapNotification!(n);
                            }
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: n.isRead ? const Color(0xFFF3F4F6) : const Color(0xFFEFF6FF),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  n.title,
                                  style: const TextStyle(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  n.message,
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}