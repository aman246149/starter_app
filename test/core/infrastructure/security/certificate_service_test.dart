import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:starter_app/core/infrastructure/security/certificate_service.dart';
import 'package:starter_app/core/logging/i_app_logger.dart';

class MockAppLogger extends Mock implements IAppLogger {}

void main() {
  group('CertificateService', () {
    late CertificateService service;
    late MockAppLogger mockLogger;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockLogger = MockAppLogger();
      service = CertificateService(mockLogger);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
    });

    test('initialize loads certificate successfully', () async {
      // Arrange
      final expectedBytes = Uint8List.fromList([1, 2, 3]);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
            'flutter/assets',
            (message) async {
              return ByteData.sublistView(expectedBytes).buffer.asByteData();
            },
          );

      // Act
      await service.initialize();

      // Assert
      expect(service.trustedCertificateBytes, equals(expectedBytes));
      verify(
        () => mockLogger.info(
          'SSL certificate loaded successfully',
          tag: 'CertificateService',
        ),
      ).called(1);
    });

    test('initialize handles missing certificate file gracefully', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
            'flutter/assets',
            (message) async {
              return null;
              // Simulates file not found (returns null to platform channel)
            },
          );

      // Act
      await service.initialize();

      // Assert
      expect(service.trustedCertificateBytes, isNull);
      verify(
        () => mockLogger.info(
          any(that: contains('No SSL certificate found')),
          tag: 'CertificateService',
        ),
      ).called(1);
    });

    test('initialize handles unexpected exceptions', () async {
      // Arrange
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler(
            'flutter/assets',
            (message) async {
              // Return an error that doesn't look like a missing asset
              return Future.error(Exception('Critical failure'));
            },
          );

      // Act
      await service.initialize();

      // Assert
      expect(service.trustedCertificateBytes, isNull);
      verify(
        () => mockLogger.error(
          'Failed to load SSL certificate',
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: 'CertificateService',
        ),
      ).called(1);
    });

    test('trustedCertificateBytes returns null before initialization', () {
      expect(service.trustedCertificateBytes, isNull);
    });
  });
}
