import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/presentation/widgets/email_text_field.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('EmailTextField Golden Tests', () {
    testWidgets('renders empty state correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: EmailTextField(
              email: EmailAddress(''),
              showError: false,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(EmailTextField),
        matchesGoldenFile('goldens/email_text_field_empty.png'),
      );
    });

    testWidgets('renders with error correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: EmailTextField(
              email: EmailAddress('invalid-email'),
              showError: true,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(EmailTextField),
        matchesGoldenFile('goldens/email_text_field_error.png'),
      );
    });
  });
}
