import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrms_ys/app/modules/attendance/services/office_geofence.dart';
import 'package:hrms_ys/app/modules/home/widgets/attendance_location_card.dart';
import 'package:hrms_ys/app/modules/home/widgets/home_attendance_card.dart';
import 'package:hrms_ys/app/shared/theme/app_color.dart';
import 'package:hrms_ys/app/shared/theme/app_theme.dart';

import 'support/montserrat_fixture.dart';

void main() {
  final messenger =
      TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger;
  setUpAll(() => mockMontserrat(messenger));
  tearDownAll(() => clearMockMontserrat(messenger));

  testWidgets('location settings action fits on a narrow screen', (
    tester,
  ) async {
    var settingsOpened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 280,
              child: MediaQuery(
                data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
                child: AttendanceLocationCard(
                  message: 'Allow location access in Settings.',
                  address: '',
                  status: null,
                  onOpenSettings: () => settingsOpened = true,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Location Settings'));
    expect(settingsOpened, isTrue);
    final message = tester.widget<Text>(
      find.text('Allow location access in Settings.'),
    );
    expect(message.style?.fontFamily, contains('Montserrat'));
    expect(message.textAlign, TextAlign.center);
    expect(find.byType(HomeAttendanceCard), findsOneWidget);
    expect(find.text('Attendance location'), findsNothing);
    final cardCenter = tester.getCenter(find.byType(HomeAttendanceCard)).dx;
    expect(
      tester.getCenter(find.byIcon(Icons.location_disabled_outlined)).dx,
      closeTo(cardCenter, .01),
    );
    expect(
      tester.getCenter(find.byType(OutlinedButton)).dx,
      closeTo(cardCenter, .01),
    );
    expect(
      tester.widget<Icon>(find.byIcon(Icons.location_disabled_outlined)).color,
      AppColor.kErrorColor,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows progress, then verified location and address', (
    tester,
  ) async {
    Future<void> showCard(AttendanceLocationCard card) => tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(body: card),
      ),
    );

    await showCard(
      const AttendanceLocationCard(
        message: 'Within the office area',
        address: 'Example office address',
        status: OfficeLocationStatus.inside,
        isChecking: true,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Verifying office location…'), findsOneWidget);
    expect(find.text('Example office address'), findsNothing);

    await showCard(
      const AttendanceLocationCard(
        message: 'Within the office area',
        address: 'Example office address',
        status: OfficeLocationStatus.inside,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Within the office area'), findsOneWidget);
    expect(find.text('Example office address'), findsOneWidget);
    expect(find.text('Open Location Settings'), findsNothing);
  });
}
