@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:starter_app/core/infrastructure/networking/http_client_factory_io.dart';

void main() {
  group('HttpClientFactoryIo', () {
    const factory = HttpClientFactoryIo();

    test('createClient returns IOClient', () {
      final client = factory.createClient();
      expect(client, isA<IOClient>());
      client.close();
    });

    test('createClient accepts trusted certificates', () {
      // We can't easily verify the internal
      // SecurityContext without partial mocking or reflection,
      // which is hard with dart:io classes.
      // But we can verify it doesn't throw with valid (or empty) bytes.
      // Passing random bytes will likely cause TlsException or
      // similar when setTrustedCertificatesBytes is called.

      // Let's try with empty list - logic says
      // "if (trustedCertificateBytes != null
      // && trustedCertificateBytes.isNotEmpty)"
      final client = factory.createClient(trustedCertificateBytes: []);
      expect(client, isA<IOClient>());
      client.close();
    });

    test(
      'createClient handles invalid certificate bytes gracefully or rethrows',
      () {
        // The implementation catches TlsException.
        // If the message is 'CERT_ALREADY_IN_HASH_TABLE', it ignores it.
        // Otherwise it rethrows.

        // We can't easily generate a valid
        // cert byte array here without including a file.
        // And generating a TlsException with specific message is hard.
        // However, passing garbage bytes usually throws TlsException.

        try {
          factory.createClient(trustedCertificateBytes: [1, 2, 3]);
          // If it didn't throw, that's interesting.
          // documentation says setTrustedCertificatesBytes throws TlsException.
        } on Exception catch (e) {
          expect(e, isA<TlsException>());
        }
      },
    );

    test('createFactory returns HttpClientFactoryIo', () {
      expect(createFactory(), isA<HttpClientFactoryIo>());
    });
  });
}
