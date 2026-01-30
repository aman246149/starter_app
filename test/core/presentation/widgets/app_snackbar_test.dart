import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/presentation/widgets/app_snackbar.dart';

void main() {
  testWidgets('AppSnackBar renders correctly', (tester) async {
    const message = 'Test Message';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  AppSnackBar(message: message),
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pumpAndSettle(); // Complete all animations

    expect(find.text(message), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
