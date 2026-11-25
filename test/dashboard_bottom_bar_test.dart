import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms_ys/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:hrms_ys/app/modules/dashboard/views/dashboard_screen.dart';
import 'package:hrms_ys/app/modules/dashboard/widgets/common_bottom_bar.dart';
import 'package:hrms_ys/app/shared/theme/app_theme.dart';

import 'support/montserrat_fixture.dart';

class _DashboardController extends DashboardController {
  @override
  List<Widget> get screens => _screens;

  final List<Widget> _screens = [
    ListView.builder(
      key: const ValueKey('home scroll'),
      itemCount: 30,
      itemBuilder: (context, index) =>
          SizedBox(height: 72, child: Text('Row $index')),
    ),
    const Center(child: Text('Attendance tab')),
    PageView(
      key: const ValueKey('updates pages'),
      children: const [
        Center(child: Text('First update page')),
        Center(child: Text('Second update page')),
      ],
    ),
    const Center(child: Text('Profile tab')),
  ];

  @override
  Future<void> changeTab(int index) async {
    if (selectedIndex == index) return;
    selectedIconSlideOffset = index > selectedIndex ? -.20 : .20;
    selectedIndex = index;
    navAnimationController.forward(from: 0);
    update();
  }
}

void main() {
  final messenger =
      TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger;
  setUpAll(() => mockMontserrat(messenger));
  tearDownAll(() => clearMockMontserrat(messenger));
  tearDown(Get.reset);

  Future<void> showDashboard(WidgetTester tester) async {
    Get.put<DashboardController>(_DashboardController());
    await tester.pumpWidget(
      GetMaterialApp(theme: AppTheme.light(), home: const DashboardScreen()),
    );
    await tester.runAsync(() => GoogleFonts.pendingFonts());
    await tester.pumpAndSettle();
  }

  testWidgets(
    'only the selected tab slides and press feedback is transparent',
    (tester) async {
      await showDashboard(tester);
      final bar = find.byType(CommonBottomBar);
      final slide = find.descendant(
        of: bar,
        matching: find.byType(SlideTransition),
      );
      final tabs = find.descendant(of: bar, matching: find.byType(InkWell));
      expect(tabs, findsNWidgets(4));
      for (final tab in tester.widgetList<InkWell>(tabs)) {
        expect(tab.splashFactory, NoSplash.splashFactory);
        expect(
          tab.overlayColor?.resolve({WidgetState.pressed}),
          Colors.transparent,
        );
      }

      await tester.tap(find.text('Profile'));
      await tester.pump();
      expect(slide, findsOneWidget);
      expect(
        tester.widget<SlideTransition>(slide).position.value.dx,
        lessThan(0),
      );
      await tester.pump(const Duration(milliseconds: 245));
      expect(
        tester.widget<SlideTransition>(slide).position.value.dx,
        greaterThan(0),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<SlideTransition>(slide).position.value, Offset.zero);

      await tester.tap(find.text('Home'));
      await tester.pump();
      expect(slide, findsOneWidget);
      expect(
        tester.widget<SlideTransition>(slide).position.value.dx,
        greaterThan(0),
      );
      await tester.pump(const Duration(milliseconds: 245));
      expect(
        tester.widget<SlideTransition>(slide).position.value.dx,
        lessThan(0),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<SlideTransition>(slide).position.value, Offset.zero);
    },
  );

  testWidgets('glass bar shrinks and expands with vertical scrolling', (
    tester,
  ) async {
    await showDashboard(tester);

    final bar = find.byType(CommonBottomBar);
    final glass = find.descendant(
      of: bar,
      matching: find.byType(BackdropFilter),
    );
    expect(glass, findsOneWidget);
    final expanded = tester.getSize(glass);

    final list = find.byKey(const ValueKey('home scroll'));
    await tester.drag(list, const Offset(0, -180));
    await tester.pumpAndSettle();

    expect(tester.widget<CommonBottomBar>(bar).compact, isTrue);
    expect(tester.getSize(glass).width, lessThan(expanded.width));
    expect(tester.getSize(glass).height, lessThan(expanded.height));
    expect(
      find.descendant(of: bar, matching: find.text('Attendance')),
      findsOneWidget,
    );

    await tester.drag(list, const Offset(0, 100));
    await tester.pumpAndSettle();

    expect(tester.widget<CommonBottomBar>(bar).compact, isFalse);
    expect(tester.getSize(glass).width, expanded.width);
    expect(tester.getSize(glass).height, closeTo(expanded.height, 1));
  });

  testWidgets(
    'tab state stays independent and horizontal swipes keep the bar expanded',
    (tester) async {
      await showDashboard(tester);
      final bar = find.byType(CommonBottomBar);
      final home = find.byKey(const ValueKey('home scroll'));
      await tester.drag(home, const Offset(0, -180));
      await tester.pumpAndSettle();
      expect(tester.widget<CommonBottomBar>(bar).compact, isTrue);

      await tester.tap(find.text('Notification'));
      await tester.pumpAndSettle();
      expect(tester.widget<CommonBottomBar>(bar).compact, isFalse);
      await tester.drag(
        find.byKey(const ValueKey('updates pages')),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('Second update page'), findsOneWidget);
      expect(tester.widget<CommonBottomBar>(bar).compact, isFalse);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(tester.widget<CommonBottomBar>(bar).compact, isTrue);
    },
  );
}
