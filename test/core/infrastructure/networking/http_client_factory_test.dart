import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/infrastructure/networking/http_client_factory.dart';

void main() {
  test('getHttpClientFactory returns an instance', () {
    final factory = getHttpClientFactory();
    expect(factory, isA<IHttpClientFactory>());
  });
}
