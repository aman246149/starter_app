import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/dashboard/presentation/pages/dashboard_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  group('DashboardPage', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpApp(const DashboardPage());

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('displays app bar with title', (tester) async {
      await tester.pumpApp(const DashboardPage());

      expect(find.byType(AppBar), findsOneWidget);
      // AppBar title comes from localization
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('displays scaffold structure', (tester) async {
      await tester.pumpApp(const DashboardPage());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('renders colored boxes in grid', (tester) async {
      await tester.pumpApp(const DashboardPage());

      // DashboardPage generates ColoredBox widgets in a responsive grid
      // The number visible depends on screen size in test environment
      expect(find.byType(ColoredBox), findsWidgets);
    });
  });
}
