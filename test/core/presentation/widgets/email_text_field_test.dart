import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/value_objects/email_address.dart';
import 'package:starter_app/core/presentation/widgets/app_text_field.dart';
import 'package:starter_app/core/presentation/widgets/email_text_field.dart';

void main() {
  group('EmailTextField', () {
    testWidgets('renders AppTextField with email configuration', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmailTextField(
              email: EmailAddress('test@example.com'),
              showError: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<AppTextField>(find.byType(AppTextField));
      expect(textField.keyboardType, TextInputType.emailAddress);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets(
      'shows validation error when showError is true and email is invalid',
      (tester) async {
        // Arrange
        final invalidEmail = EmailAddress('invalid');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmailTextField(
                email: invalidEmail,
                showError: true,
              ),
            ),
          ),
        );

        // Assert
        expect(
          find.text('Entered value is not a valid email address'),
          findsOneWidget,
        );
      },
    );

    testWidgets('does not show validation error when showError is false', (
      tester,
    ) async {
      // Arrange
      final invalidEmail = EmailAddress('invalid');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmailTextField(
              email: invalidEmail,
              showError: false,
            ),
          ),
        ),
      );

      // Assert
      expect(
        find.text('Entered value is not a valid email address'),
        findsNothing,
      );
    });

    testWidgets(
      'shows tooLong error when email exceeds max length',
      (tester) async {
        // Arrange - Create email longer than 254 characters
        final longEmail = 'a' * 250 + '@example.com'; // 263 chars
        final invalidEmail = EmailAddress(longEmail);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmailTextField(
                email: invalidEmail,
                showError: true,
              ),
            ),
          ),
        );

        // Assert
        expect(
          find.textContaining('Cannot be longer than 254 characters'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows empty error when email is empty',
      (tester) async {
        // Arrange
        final emptyEmail = EmailAddress('');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmailTextField(
                email: emptyEmail,
                showError: true,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Email cannot be empty'), findsOneWidget);
      },
    );

    testWidgets(
      'does not show error when email is valid',
      (tester) async {
        // Arrange
        final validEmail = EmailAddress('test@example.com');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmailTextField(
                email: validEmail,
                showError: true,
              ),
            ),
          ),
        );

        // Assert - No error messages should be shown
        expect(find.text('Email cannot be empty'), findsNothing);
        expect(
          find.text('Entered value is not a valid email address'),
          findsNothing,
        );
        expect(
          find.textContaining('Cannot be longer than'),
          findsNothing,
        );
      },
    );
  });
}
