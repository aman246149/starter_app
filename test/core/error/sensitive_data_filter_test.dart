// ignore_for_file: prefer_const_constructors - to test const constructor

import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/domain/ports/i_data_filter.dart';
import 'package:starter_app/core/error/sensitive_data_filter.dart';

void main() {
  group('SensitiveDataFilter', () {
    late SensitiveDataFilter filter;

    setUp(() {
      filter = SensitiveDataFilter();
    });

    group('constructor', () {
      test('should be const constructible', () {
        const filter1 = SensitiveDataFilter();
        const filter2 = SensitiveDataFilter();
        expect(filter1, equals(filter2));
      });

      test('should implement IDataFilter', () {
        expect(filter, isA<IDataFilter>());
      });
    });

    group('filter', () {
      test('should return empty map for empty input', () {
        final result = filter.filter({});
        expect(result, isEmpty);
      });

      test('should pass through non-sensitive keys', () {
        final data = {
          'name': 'John',
          'age': 30,
          'city': 'New York',
        };

        final result = filter.filter(data);

        expect(result['name'], equals('John'));
        expect(result['age'], equals(30));
        expect(result['city'], equals('New York'));
      });

      test('should redact password field', () {
        final data = {'password': 'secret123'};
        final result = filter.filter(data);
        expect(result['password'], equals('***REDACTED***'));
      });

      test('should redact token field', () {
        final data = {'token': 'abc123'};
        final result = filter.filter(data);
        expect(result['token'], equals('***REDACTED***'));
      });

      test('should redact authorization field', () {
        final data = {'authorization': 'Bearer xxx'};
        final result = filter.filter(data);
        expect(result['authorization'], equals('***REDACTED***'));
      });

      test('should redact auth field', () {
        final data = {'auth': 'credentials'};
        final result = filter.filter(data);
        expect(result['auth'], equals('***REDACTED***'));
      });

      test('should redact api_key field', () {
        final data = {'api_key': 'key123'};
        final result = filter.filter(data);
        expect(result['api_key'], equals('***REDACTED***'));
      });

      test('should redact apikey field', () {
        final data = {'apikey': 'key123'};
        final result = filter.filter(data);
        expect(result['apikey'], equals('***REDACTED***'));
      });

      test('should redact secret field', () {
        final data = {'secret': 'mysecret'};
        final result = filter.filter(data);
        expect(result['secret'], equals('***REDACTED***'));
      });

      test('should redact credential field', () {
        final data = {'credential': 'mycred'};
        final result = filter.filter(data);
        expect(result['credential'], equals('***REDACTED***'));
      });

      test('should redact credit_card field', () {
        final data = {'credit_card': '1234-5678'};
        final result = filter.filter(data);
        expect(result['credit_card'], equals('***REDACTED***'));
      });

      test('should redact creditcard field', () {
        final data = {'creditcard': '1234-5678'};
        final result = filter.filter(data);
        expect(result['creditcard'], equals('***REDACTED***'));
      });

      test('should redact ssn field', () {
        final data = {'ssn': '123-45-6789'};
        final result = filter.filter(data);
        expect(result['ssn'], equals('***REDACTED***'));
      });

      test('should redact social_security field', () {
        final data = {'social_security': '123-45-6789'};
        final result = filter.filter(data);
        expect(result['social_security'], equals('***REDACTED***'));
      });

      test('should redact pin field', () {
        final data = {'pin': '1234'};
        final result = filter.filter(data);
        expect(result['pin'], equals('***REDACTED***'));
      });

      test('should redact cvv field', () {
        final data = {'cvv': '123'};
        final result = filter.filter(data);
        expect(result['cvv'], equals('***REDACTED***'));
      });

      test('should redact card_number field', () {
        final data = {'card_number': '1234567890'};
        final result = filter.filter(data);
        expect(result['card_number'], equals('***REDACTED***'));
      });

      test('should redact cardnumber field', () {
        final data = {'cardnumber': '1234567890'};
        final result = filter.filter(data);
        expect(result['cardnumber'], equals('***REDACTED***'));
      });

      test(
        'should redact keys containing sensitive terms (case-insensitive)',
        () {
          final data = {
            'userPassword': 'secret',
            'ACCESS_TOKEN': 'token123',
            'AuthHeader': 'bearer abc',
          };

          final result = filter.filter(data);

          expect(result['userPassword'], equals('***REDACTED***'));
          expect(result['ACCESS_TOKEN'], equals('***REDACTED***'));
          expect(result['AuthHeader'], equals('***REDACTED***'));
        },
      );

      test('should recursively filter nested maps', () {
        final data = {
          'user': {
            'name': 'John',
            'password': 'secret',
            'profile': {
              'age': 30,
              'api_key': 'key123',
            },
          },
        };

        final result = filter.filter(data);
        final user = result['user'] as Map<String, dynamic>;
        final profile = user['profile'] as Map<String, dynamic>;

        expect(user['name'], equals('John'));
        expect(user['password'], equals('***REDACTED***'));
        expect(profile['age'], equals(30));
        expect(profile['api_key'], equals('***REDACTED***'));
      });

      test('should preserve original key casing', () {
        final data = {'PASSWORD': 'secret'};
        final result = filter.filter(data);
        expect(result.containsKey('PASSWORD'), isTrue);
        expect(result['PASSWORD'], equals('***REDACTED***'));
      });

      test('should preserve non-map values in nested structures', () {
        final data = {
          'items': [1, 2, 3],
          'count': 5,
          'active': true,
        };

        final result = filter.filter(data);

        expect(result['items'], equals([1, 2, 3]));
        expect(result['count'], equals(5));
        expect(result['active'], equals(true));
      });
    });

    group('shouldFilter', () {
      test('should return true for password', () {
        expect(filter.shouldFilter('password'), isTrue);
      });

      test('should return true for token', () {
        expect(filter.shouldFilter('token'), isTrue);
      });

      test('should return true for keys containing sensitive terms', () {
        expect(filter.shouldFilter('userPassword'), isTrue);
        expect(filter.shouldFilter('access_token'), isTrue);
        expect(filter.shouldFilter('api_key_header'), isTrue);
      });

      test('should return false for non-sensitive keys', () {
        expect(filter.shouldFilter('name'), isFalse);
        expect(filter.shouldFilter('email'), isFalse);
        expect(filter.shouldFilter('userId'), isFalse);
      });

      test('should be case-insensitive', () {
        expect(filter.shouldFilter('PASSWORD'), isTrue);
        expect(filter.shouldFilter('Token'), isTrue);
        expect(filter.shouldFilter('API_KEY'), isTrue);
      });
    });

    group('static constants', () {
      test('sensitiveTerms should contain all expected terms', () {
        expect(
          SensitiveDataFilter.sensitiveTerms,
          containsAll([
            'password',
            'token',
            'authorization',
            'auth',
            'api_key',
            'apikey',
            'secret',
            'credential',
            'credit_card',
            'creditcard',
            'ssn',
            'social_security',
            'pin',
            'cvv',
            'card_number',
            'cardnumber',
          ]),
        );
      });

      test('redactedValue should be ***REDACTED***', () {
        expect(SensitiveDataFilter.redactedValue, equals('***REDACTED***'));
      });
    });
  });
}
