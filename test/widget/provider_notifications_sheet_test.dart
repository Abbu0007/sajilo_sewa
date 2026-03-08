import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/view_model/provider_notifications_controller.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/home/provider_notifications_sheet.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_notifications_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/mark_provider_notification_read_usecase.dart';

class MockGetProviderNotificationsUseCase extends Mock
    implements GetProviderNotificationsUseCase {}

class MockMarkProviderNotificationReadUseCase extends Mock
    implements MarkProviderNotificationReadUseCase {}

void main() {
  testWidgets('provider notifications sheet renders', (tester) async {

    final getNotifications = MockGetProviderNotificationsUseCase();
    final markRead = MockMarkProviderNotificationReadUseCase();

    final controller = ProviderNotificationsController(
      getNotifications: getNotifications,
      markRead: markRead,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderNotificationsSheet(
            controller: controller,
            onTapNotification: (_) async {},
          ),
        ),
      ),
    );

    expect(find.byType(ProviderNotificationsSheet), findsOneWidget);
  });
}