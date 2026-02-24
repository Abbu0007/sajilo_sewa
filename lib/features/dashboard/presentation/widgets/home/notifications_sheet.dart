import 'package:flutter/material.dart';
import '../../view_model/home_notifications_controller.dart';
import '../ratings/rating_sheet.dart';

class HomeNotificationsSheet extends StatelessWidget {
  final HomeNotificationsController controller;

  const HomeNotificationsSheet({super.key, required this.controller});

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

                        final isRatingRequest = (n.type ?? "") == "rating_request";
                        final bookingId = (n.bookingId ?? "").trim();

                        return InkWell(
                          onTap: () async {
                            if (isRatingRequest && bookingId.isNotEmpty) {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                                ),
                                builder: (_) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  child: RatingSheet(
                                    title: n.title,
                                    subtitle: n.message,
                                    onSubmit: (stars, comment) async {
                                      await controller.submitRatingFromNotification(
                                        notificationId: n.id,
                                        bookingId: bookingId,
                                        stars: stars,
                                        comment: comment,
                                      );
                                    },
                                  ),
                                ),
                              );
                              return;
                            }

                            // normal: mark read
                            if (!n.isRead) {
                              await controller.markAsReadAndRefresh(n.id);
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        n.title,
                                        style: const TextStyle(fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                    if (isRatingRequest)
                                      const Icon(Icons.star, color: Colors.amber, size: 18),
                                  ],
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