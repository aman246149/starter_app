import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/l10n/arb/app_localizations.dart';
import 'package:starter_app/core/presentation/failure_message/infrastructure_failure_mapper.dart';

import '../../../helpers/mock_helpers.dart';

void main() {
  group('InfrastructureFailureMapper', () {
    late MockFailureMapperRegistry mockRegistry;
    late InfrastructureFailureMapper mapper;

    setUp(() {
      mockRegistry = MockFailureMapperRegistry();
      mapper = InfrastructureFailureMapper(mockRegistry);
    });

    test('registers itself with registry with low priority', () {
      verify(
        () => mockRegistry.register(mapper, highPriority: false),
      ).called(1);
    });

    test('canHandle returns true for InfrastructureFailure', () {
      expect(mapper.canHandle(const InfrastructureFailure.network()), true);
    });

    testWidgets('map returns correct localized strings', (tester) async {
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
              final mapper = InfrastructureFailureMapper(
                MockFailureMapperRegistry(),
              );

              expect(
                mapper.map(context, const InfrastructureFailure.network()),
                "Couldn't connect to the server. Please check your connection",
              );
              expect(
                mapper.map(
                  context,
                  const InfrastructureFailure.server(
                    message: 'Error',
                    statusCode: 500,
                  ),
                ),
                contains('Something went wrong'),
              );
              expect(
                mapper.map(context, const InfrastructureFailure.cache()),
                'Local storage error',
              );
              expect(
                mapper.map(context, const InfrastructureFailure.parse()),
                'Invalid data format received. Please contact support.',
              );
              expect(
                mapper.map(
                  context,
                  const InfrastructureFailure.circuitBreaker(),
                ),
                contains('Circuit breaker tripped'),
              );
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
