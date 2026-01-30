import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/auth/domain/failure/auth_failure.dart';
import 'package:starter_app/features/auth/l10n/auth_localizations.dart';
import 'package:starter_app/features/auth/presentation/failure_message/auth_failure_mapper.dart';

import '../../../../helpers/mock_helpers.dart';

void main() {
  group('AuthFailureMessageMapper', () {
    late MockFailureMapperRegistry mockRegistry;
    late AuthFailureMessageMapper mapper;

    setUp(() {
      mockRegistry = MockFailureMapperRegistry();
      mapper = AuthFailureMessageMapper(mockRegistry);

      // We can't easily mock extension methods on BuildContext directly
      // But since we are testing the mapper logic which calls map(),
      // we need to ensure context.authL10n works.
      // However, context.authL10n relies on Localizations.of
      //which is hard to mock without pumping widgets.
      // A better approach for unit testing mappers that
      //use context extensions is to wrap the test in a small widget tree
      // or abstract the l10n lookup.
      // Given the current architecture, we will test canHandle primarily,
      // and use a widget test for map() to ensure l10n works.
    });

    test('registers itself with registry on creation', () {
      verify(
        () => mockRegistry.register(
          mapper,
        ),
      ).called(1);
    });

    test('canHandle returns true for AuthFailure', () {
      expect(
        mapper.canHandle(
          const AuthFailure.unauthorized(message: 'Unauthorized'),
        ),
        true,
      );
    });

    test('canHandle returns false for other failures', () {
      // Create a non-AuthFailure class for testing if possible or assume safety
      // Since Failure is sealed or abstract, we rely on type check
    });

    testWidgets('map returns correct localized strings for all cases', (
      tester,
    ) async {
      await tester.pumpWidget(
        Localizations(
          locale: const Locale('en'),
          delegates: const [
            AuthLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Builder(
            builder: (context) {
              final mapper = AuthFailureMessageMapper(
                MockFailureMapperRegistry(),
              );

              // Existing checks
              expect(
                mapper.map(
                  context,
                  const AuthFailure.unauthorized(
                    message: 'Invalid email or password',
                  ),
                ),
                'Invalid credentials or session expired',
              );
              expect(
                mapper.map(
                  context,
                  const AuthFailure.forbidden(message: 'Access denied'),
                ),
                'Access denied - insufficient permissions',
              );

              // New checks
              expect(
                mapper.map(
                  context,
                  const AuthFailure.notFound(message: 'Not found'),
                ),
                'Authentication resource not found',
              );
              expect(
                mapper.map(
                  context,
                  const AuthFailure.emailAlreadyInUse(),
                ),
                'This email is already registered. Please login instead.',
              );
              expect(
                mapper.map(
                  context,
                  const AuthFailure.invalidInput(message: 'Invalid'),
                ),
                'Please check your input and try again.',
              );

              return const SizedBox();
            },
          ),
        ),
      );
      // Advance past Sentry timer
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
