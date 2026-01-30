import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/presentation/widgets/app_text_field.dart';

void main() {
  group('AppTextField', () {
    testWidgets('renders correctly with label and hint', (tester) async {
      const label = 'Test Label';
      const hint = 'Test Hint';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: label,
              hint: hint,
            ),
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      expect(find.text(label), findsOneWidget);
      expect(find.text(hint), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('displays error text when provided', (tester) async {
      const errorText = 'Error message';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              errorText: errorText,
            ),
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      expect(find.text(errorText), findsOneWidget);
    });

    testWidgets('handles text input', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      await tester.enterText(find.byType(AppTextField), 'test input');
      expect(changedValue, 'test input');
    });

    testWidgets('shows prefix and suffix icons', (tester) async {
      const prefixKey = Key('prefix');
      const suffixKey = Key('suffix');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              prefixIcon: Icon(Icons.person, key: prefixKey),
              suffixIcon: Icon(Icons.check, key: suffixKey),
            ),
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      expect(find.byKey(prefixKey), findsOneWidget);
      expect(find.byKey(suffixKey), findsOneWidget);
    });

    testWidgets('unfocuses when tapping outside', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppTextField(
                  focusNode: focusNode,
                  autofocus: true,
                ),
                const SizedBox(height: 100),
                const Text('Outside area'),
              ],
            ),
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));

      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      // Tap outside the text field
      await tester.tap(find.text('Outside area'));
      await tester.pump();

      expect(focusNode.hasFocus, isFalse);
    });
  });
}
