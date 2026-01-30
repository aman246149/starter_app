import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/features/profile/domain/failure/profile_failure.dart';
import 'package:starter_app/features/profile/l10n/profile_localizations.dart';
import 'package:starter_app/features/profile/presentation/failure_message/profile_failure_mapper.dart';

import '../../../../helpers/mock_helpers.dart';

void main() {
  group('ProfileFailureMapper', () {
    late MockFailureMapperRegistry mockRegistry;
    late ProfileFailureMapper mapper;

    setUp(() {
      mockRegistry = MockFailureMapperRegistry();
      mapper = ProfileFailureMapper(mockRegistry);
    });

    test('registers itself with registry on creation', () {
      verify(() => mockRegistry.register(mapper)).called(1);
    });

    test('canHandle returns true for ProfileFailure', () {
      expect(
        mapper.canHandle(const ProfileFailure.unexpected(message: 'Error')),
        isTrue,
      );
    });

    testWidgets('map returns correct localized strings for all cases', (
      tester,
    ) async {
      await tester.pumpWidget(
        Localizations(
          locale: const Locale('en'),
          delegates: const [
            ProfileLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Builder(
            builder: (context) {
              // Re-create mapper inside builder if needed,
              // but the one from setUp works
              // as strictly unit test, except map() needs context.
              // Actually map() method needs context with ProfileLocalizations.

              expect(
                mapper.map(
                  context,
                  const ProfileFailure.unexpected(message: 'Unexpected'),
                ),
                'An unexpected error occurred.',
              );

              expect(
                mapper.map(
                  context,
                  const ProfileFailure.serverError(message: 'Server error'),
                ),
                'A server error occurred. Please try again later.',
              );

              expect(
                mapper.map(
                  context,
                  const ProfileFailure.notFound(message: 'Not found'),
                ),
                'Profile not found.',
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
