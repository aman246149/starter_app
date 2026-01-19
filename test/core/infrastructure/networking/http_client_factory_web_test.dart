import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:starter_app/core/infrastructure/networking/http_client_factory_web.dart';

void main() {
  group('HttpClientFactoryWeb', () {
    const factory = HttpClientFactoryWeb();

    test('createClient returns http.Client', () {
      final client = factory.createClient();
      expect(client, isA<http.Client>());
      client.close();
    });

    test('createClient ignores certificates', () {
      final client = factory.createClient(trustedCertificateBytes: [1, 2, 3]);
      expect(client, isA<http.Client>());
      client.close();
    });

    test('createFactory returns HttpClientFactoryWeb', () {
      expect(createFactory(), isA<HttpClientFactoryWeb>());
    });
  });
}
