import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/failures/failure.dart';
import 'package:starter_app/core/l10n/arb/app_localizations.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';
import 'package:starter_app/core/presentation/failure_message/failure_mapper_registry.dart';
import 'package:starter_app/core/presentation/failure_message/failure_message_mapper.dart';
import 'package:starter_app/core/presentation/services/failure_message_service.dart';

class MockFailureMapperRegistry extends Mock implements FailureMapperRegistry {}

class MockAppLogger extends Mock implements IAppLogger {}

class MockFailureMessageMapper extends Mock implements FailureMessageMapper {}

class MockBuildContext extends Mock implements BuildContext {}

// Create a concrete failure for testing runtime type matching
class TestFailure extends Failure {
  @override
  bool get isRetryable => false;

  @override
  String get message => 'Test failure message';
}

void main() {
  late MockFailureMapperRegistry registry;
  late MockAppLogger logger;
  late FailureMessageService service;
  late MockBuildContext context;

  setUp(() {
    registry = MockFailureMapperRegistry();
    logger = MockAppLogger();
    service = FailureMessageService(registry, logger);
    context = MockBuildContext();
  });

  group('FailureMessageService', () {
    test(
      'getLocalizedMessage should return mapped message when mapper exists',
      () {
        // Arrange
        final failure = TestFailure();
        final mapper = MockFailureMessageMapper();

        when(() => registry.all).thenReturn([mapper]);
        when(() => mapper.canHandle(failure)).thenReturn(true);
        when(() => mapper.map(context, failure)).thenReturn('error message');

        // Act
        final result = service.getLocalizedMessage(context, failure);

        // Assert
        expect(result, 'error message');
        verify(() => mapper.canHandle(failure)).called(1);
        verify(() => mapper.map(context, failure)).called(1);
      },
    );

    test(
      'getLocalizedMessage should use cached mapper on subsequent calls',
      () {
        // Arrange
        final failure = TestFailure();
        final mapper = MockFailureMessageMapper();

        when(() => registry.all).thenReturn([mapper]);
        when(() => mapper.canHandle(failure)).thenReturn(true);
        when(() => mapper.map(context, failure)).thenReturn('error message');

        // Act
        service
          ..getLocalizedMessage(context, failure) // First call
          ..getLocalizedMessage(context, failure); // Second call

        // Assert
        verify(
          () => mapper.canHandle(failure),
        ).called(1); // Only called once due to caching
        verify(() => mapper.map(context, failure)).called(2);
      },
    );

    testWidgets(
      'getLocalizedMessage should return fallback message when no mapper found',
      (tester) async {
        // Arrange
        final failure = TestFailure();
        when(() => registry.all).thenReturn([]);

        // Act & Assert
        await tester.pumpWidget(
          Localizations(
            locale: const Locale('en'),
            delegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            child: Builder(
              builder: (context) {
                final result = service.getLocalizedMessage(context, failure);
                expect(result, 'An unexpected error occurred');
                verify(() => logger.warning(any())).called(1);
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );

    testWidgets(
      'getLocalizedMessage should return fallback when mapper throws exception',
      (tester) async {
        // Arrange
        final failure = TestFailure();
        final mapper = MockFailureMessageMapper();
        final exception = Exception('Mapper error');

        when(() => registry.all).thenReturn([mapper]);
        when(() => mapper.canHandle(failure)).thenReturn(true);

        // Act & Assert
        await tester.pumpWidget(
          Localizations(
            locale: const Locale('en'),
            delegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            child: Builder(
              builder: (context) {
                // Set up the mock to throw when map is called with this context
                when(() => mapper.map(context, failure)).thenThrow(exception);

                final result = service.getLocalizedMessage(context, failure);
                expect(result, 'An unexpected error occurred');
                verify(
                  () => logger.error(
                    any(),
                    error: exception,
                    stackTrace: any(named: 'stackTrace'),
                  ),
                ).called(1);
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );

    testWidgets(
      'getLocalizedMessage should cache mapper after first lookup',
      (tester) async {
        // Arrange
        final failure = TestFailure();
        final mapper = MockFailureMessageMapper();

        when(() => registry.all).thenReturn([mapper]);
        when(() => mapper.canHandle(failure)).thenReturn(true);

        BuildContext? testContext;

        // Act & Assert
        await tester.pumpWidget(
          Localizations(
            locale: const Locale('en'),
            delegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            child: Builder(
              builder: (context) {
                testContext = context;
                // Set up the mock to return message when map is called
                when(
                  () => mapper.map(context, failure),
                ).thenReturn('cached message');

                // First call - should search registry
                final result1 = service.getLocalizedMessage(context, failure);
                expect(result1, 'cached message');

                // Second call - should use cache (no canHandle call)
                final result2 = service.getLocalizedMessage(context, failure);
                expect(result2, 'cached message');

                return const SizedBox();
              },
            ),
          ),
        );

        // Verify canHandle was only called once (cached after first call)
        verify(() => mapper.canHandle(failure)).called(1);
        // Verify map was called twice (once per getLocalizedMessage call)
        verify(() => mapper.map(testContext!, failure)).called(2);
      },
    );

    testWidgets(
      'getLocalizedMessage should try multiple mappers until one handles it',
      (tester) async {
        // Arrange
        final failure = TestFailure();
        final mapper1 = MockFailureMessageMapper();
        final mapper2 = MockFailureMessageMapper();

        when(() => registry.all).thenReturn([mapper1, mapper2]);
        when(() => mapper1.canHandle(failure)).thenReturn(false);
        when(() => mapper2.canHandle(failure)).thenReturn(true);

        // Act & Assert
        await tester.pumpWidget(
          Localizations(
            locale: const Locale('en'),
            delegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            child: Builder(
              builder: (context) {
                // Set up the mock to return message when map is called
                when(
                  () => mapper2.map(context, failure),
                ).thenReturn('second mapper message');

                final result = service.getLocalizedMessage(context, failure);
                expect(result, 'second mapper message');
                verify(() => mapper1.canHandle(failure)).called(1);
                verify(() => mapper2.canHandle(failure)).called(1);
                verify(() => mapper2.map(context, failure)).called(1);
                verifyNever(() => mapper1.map(context, failure));
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  });
}
