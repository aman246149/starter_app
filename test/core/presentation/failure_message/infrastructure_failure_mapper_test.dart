import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/error/failures/infrastructure_failures.dart';
import 'package:starter_app/core/presentation/failure_message/infrastructure_failure_mapper.dart';

import '../../../helpers/mock_helpers.dart';
import '../../../helpers/pump_app.dart';

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

    group('map', () {
      testWidgets('maps network failure to correct message', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              final message = mapper.map(
                context,
                const InfrastructureFailure.network(),
              );
              expect(message, isNotEmpty);
              expect(message.toLowerCase(), contains('connect'));
              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('maps server failure to correct message', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              final message = mapper.map(
                context,
                const InfrastructureFailure.server(
                  message: 'Error',
                  statusCode: 500,
                ),
              );
              expect(message, isNotEmpty);
              expect(message.toLowerCase(), contains('wrong'));
              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('maps cache failure to correct message', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              final message = mapper.map(
                context,
                const InfrastructureFailure.cache(),
              );
              expect(message, isNotEmpty);
              expect(message.toLowerCase(), contains('storage'));
              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('maps parse failure to correct message', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              final message = mapper.map(
                context,
                const InfrastructureFailure.parse(),
              );
              expect(message, isNotEmpty);
              expect(message.toLowerCase(), contains('data'));
              return const SizedBox();
            },
          ),
        );
      });

      testWidgets('maps circuitBreaker failure to correct message', (
        tester,
      ) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              final message = mapper.map(
                context,
                const InfrastructureFailure.circuitBreaker(),
              );
              expect(message, isNotEmpty);
              expect(message.toLowerCase(), contains('circuit'));
              return const SizedBox();
            },
          ),
        );
      });
    });
  });
}
