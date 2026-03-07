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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final handleColor =
        isDark ? const Color(0xFF4B5563) : Colors.grey.shade300;
    final emptyTextColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;

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
                    color: handleColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Notifications",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
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
                  _NotificationsErrorBox(
                    message: controller.error!,
                    onRetry: controller.load,
                  )
                else if (controller.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Text(
                      "No notifications at the moment",
                      style: TextStyle(
                        color: emptyTextColor,
                        fontWeight: FontWeight.w700,
                      ),
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
                        return _NotificationTile(
                          notification: n,
                          onTap: () async {
                            if (!n.isRead) {
                              await controller.markAsReadAndRefresh(n.id);
                            }

                            if (onTapNotification != null) {
                              await onTapNotification!(n);
                            }
                          },
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

class _NotificationTile extends StatelessWidget {
  final ProviderNotificationEntity notification;
  final Future<void> Function() onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final readBg =
        isDark ? const Color(0xFF161A22) : const Color(0xFFF3F4F6);
    final unreadBg =
        isDark ? const Color(0xFF1A2333) : const Color(0xFFEFF6FF);
    final borderColor =
        isDark ? const Color(0xFF2A3140) : const Color(0xFFE5E7EB);
    final messageColor =
        isDark ? const Color(0xFF9CA3AF) : Colors.grey.shade700;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: notification.isRead ? readBg : unreadBg,
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              notification.message,
              style: TextStyle(color: messageColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _NotificationsErrorBox({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark ? const Color(0xFF2A1517) : const Color(0xFFFEF2F2),
        border: Border.all(
          color: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFCA5A5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFF991B1B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}