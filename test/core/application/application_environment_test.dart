import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/application/application_environment.dart';

void main() {
  group('AppEnvironment', () {
    group('enum values', () {
      test('has three environment values', () {
        expect(AppEnvironment.values.length, 3);
        expect(AppEnvironment.values, contains(AppEnvironment.development));
        expect(AppEnvironment.values, contains(AppEnvironment.staging));
        expect(AppEnvironment.values, contains(AppEnvironment.production));
      });

      test('development is first value', () {
        expect(AppEnvironment.values.first, AppEnvironment.development);
      });

      test('production is last value', () {
        expect(AppEnvironment.values.last, AppEnvironment.production);
      });
    });

    group('static constants', () {
      test('devEnv constant matches development name', () {
        expect(AppEnvironment.devEnv, 'development');
        expect(AppEnvironment.devEnv, AppEnvironment.development.name);
      });

      test('stagingEnv constant matches staging name', () {
        expect(AppEnvironment.stagingEnv, 'staging');
        expect(AppEnvironment.stagingEnv, AppEnvironment.staging.name);
      });

      test('prodEnv constant matches production name', () {
        expect(AppEnvironment.prodEnv, 'production');
        expect(AppEnvironment.prodEnv, AppEnvironment.production.name);
      });
    });

    group('current', () {
      test('defaults to development when ENVIRONMENT is not set', () {
        // In strict mode, accessing current without ENVIRONMENT throws.
        // We skip this test if strict mode is enabled.
        if (const bool.fromEnvironment('STRICT_ENV')) {
          markTestSkipped('Skipping default fallback test in strict mode');
        }

        // When ENVIRONMENT is not provided, it defaults to development
        // Note: This test assumes no compile-time ENVIRONMENT is set
        // In actual builds, this would be set via --dart-define-from-file
        final current = AppEnvironment.current;
        expect(current, AppEnvironment.development);
      });
    });

    group('getCurrentWithStrictMode', () {
      test('returns development when strictMode is false and env is empty', () {
        final result = AppEnvironment.getCurrentWithStrictMode(
          '',
          strictMode: false,
        );
        expect(result, AppEnvironment.development);
      });

      test('returns parsed environment when strictMode is false', () {
        expect(
          AppEnvironment.getCurrentWithStrictMode(
            'staging',
            strictMode: false,
          ),
          AppEnvironment.staging,
        );
        expect(
          AppEnvironment.getCurrentWithStrictMode(
            'production',
            strictMode: false,
          ),
          AppEnvironment.production,
        );
      });

      test(
        'returns development when strictMode is false and env is invalid',
        () {
          final result = AppEnvironment.getCurrentWithStrictMode(
            'invalid',
            strictMode: false,
          );
          expect(result, AppEnvironment.development);
        },
      );

      test('returns environment when strictMode is true and env is valid', () {
        expect(
          AppEnvironment.getCurrentWithStrictMode(
            'development',
            strictMode: true,
          ),
          AppEnvironment.development,
        );
        expect(
          AppEnvironment.getCurrentWithStrictMode(
            'staging',
            strictMode: true,
          ),
          AppEnvironment.staging,
        );
        expect(
          AppEnvironment.getCurrentWithStrictMode(
            'production',
            strictMode: true,
          ),
          AppEnvironment.production,
        );
      });

      test('throws StateError when strictMode is true and env is empty', () {
        expect(
          () => AppEnvironment.getCurrentWithStrictMode(
            '',
            strictMode: true,
          ),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('STRICT_ENV is enabled but ENVIRONMENT "" is invalid'),
            ),
          ),
        );
      });

      test('throws StateError when strictMode is true and env is invalid', () {
        expect(
          () => AppEnvironment.getCurrentWithStrictMode(
            'invalid',
            strictMode: true,
          ),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('STRICT_ENV is enabled'),
                contains('"invalid" is invalid'),
                contains('Valid values:'),
              ),
            ),
          ),
        );
      });
    });

    group('isExplicitlyConfigured', () {
      test('returns false when ENVIRONMENT is not set', () {
        expect(AppEnvironment.isExplicitlyConfigured, isFalse);
      });
    });

    group('configurationWarning', () {
      test('returns null when ENVIRONMENT is not set', () {
        expect(AppEnvironment.configurationWarning, isNull);
      });
    });

    group('helper methods', () {
      group('isConfigured', () {
        test('returns false for empty string', () {
          expect(AppEnvironment.isConfigured(''), isFalse);
        });

        test('returns true for valid environments', () {
          expect(AppEnvironment.isConfigured('development'), isTrue);
          expect(AppEnvironment.isConfigured('staging'), isTrue);
          expect(AppEnvironment.isConfigured('production'), isTrue);
        });

        test('returns false for invalid environment', () {
          expect(AppEnvironment.isConfigured('invalid'), isFalse);
        });

        test('is case insensitive', () {
          expect(AppEnvironment.isConfigured('DEVELOPMENT'), isTrue);
        });
      });

      group('parse', () {
        test('returns development for empty string', () {
          expect(AppEnvironment.parse(''), AppEnvironment.development);
        });

        test('returns correct environment for valid strings', () {
          expect(
            AppEnvironment.parse('development'),
            AppEnvironment.development,
          );
          expect(AppEnvironment.parse('staging'), AppEnvironment.staging);
          expect(AppEnvironment.parse('production'), AppEnvironment.production);
        });

        test('returns development for invalid string', () {
          expect(AppEnvironment.parse('invalid'), AppEnvironment.development);
        });

        test('is case insensitive', () {
          expect(AppEnvironment.parse('STAGING'), AppEnvironment.staging);
        });
      });

      group('validate', () {
        test('returns null for empty string', () {
          expect(AppEnvironment.validate(''), isNull);
        });

        test('returns null for valid environments', () {
          expect(AppEnvironment.validate('development'), isNull);
          expect(AppEnvironment.validate('staging'), isNull);
          expect(AppEnvironment.validate('production'), isNull);
        });

        test('returns warning message for invalid environment', () {
          final warning = AppEnvironment.validate('invalid');
          expect(warning, isNotNull);
          expect(warning, contains('Unknown ENVIRONMENT value: "invalid"'));
          expect(warning, contains('Defaulting to "development"'));
        });

        test('is case insensitive', () {
          expect(AppEnvironment.validate('PRODUCTION'), isNull);
        });
      });
    });

    group('isDevelopment', () {
      test('returns true when current is development', () {
        // This will be true when ENVIRONMENT is not set or is 'development'
        final isDev = AppEnvironment.isDevelopment;
        // Since current defaults to development, this should be true
        expect(isDev, isTrue);
      });
    });

    group('isStaging', () {
      test('returns false when current is not staging', () {
        // When ENVIRONMENT is not set, current defaults to development
        final isStaging = AppEnvironment.isStaging;
        expect(isStaging, isFalse);
      });
    });

    group('isProduction', () {
      test('returns false when current is not production', () {
        // When ENVIRONMENT is not set, current defaults to development
        final isProd = AppEnvironment.isProduction;
        expect(isProd, isFalse);
      });
    });

    group('sentryEnabled', () {
      test('returns false for development', () {
        expect(AppEnvironment.development.sentryEnabled, false);
      });

      test('returns true for staging', () {
        expect(AppEnvironment.staging.sentryEnabled, true);
      });

      test('returns true for production', () {
        expect(AppEnvironment.production.sentryEnabled, true);
      });
    });

    group('sslPinningEnabled', () {
      test('returns false for development', () {
        expect(AppEnvironment.development.sslPinningEnabled, false);
      });

      test('returns true for staging', () {
        expect(AppEnvironment.staging.sslPinningEnabled, true);
      });

      test('returns true for production', () {
        expect(AppEnvironment.production.sslPinningEnabled, true);
      });
    });

    group('sentryDsn', () {
      test('returns null for development', () {
        final dsn = AppEnvironment.development.sentryDsn;
        expect(dsn, isNull);
      });

      test('returns null for staging when SENTRY_DSN is not set', () {
        // When SENTRY_DSN is not provided, it returns null
        final dsn = AppEnvironment.staging.sentryDsn;
        expect(dsn, isNull);
      });

      test('returns null for production when SENTRY_DSN is not set', () {
        // When SENTRY_DSN is not provided, it returns null
        final dsn = AppEnvironment.production.sentryDsn;
        expect(dsn, isNull);
      });
    });

    group('sentrySampleRate', () {
      test('returns 0.0 for development', () {
        expect(AppEnvironment.development.sentrySampleRate, 0.0);
      });

      test('returns 1.0 for staging', () {
        expect(AppEnvironment.staging.sentrySampleRate, 1.0);
      });

      test('returns 0.1 for production', () {
        expect(AppEnvironment.production.sentrySampleRate, 0.1);
      });
    });

    group('apiBaseUrl', () {
      test(
        '''returns default localhost URL for development when API_URL not set''',
        () {
          final url = AppEnvironment.development.apiBaseUrl;
          expect(url, 'http://localhost:3000');
        },
      );

      test('returns default staging URL for staging when API_URL not set', () {
        final url = AppEnvironment.staging.apiBaseUrl;
        expect(url, 'https://api-staging.example.com');
      });

      test(
        'returns default production URL for production when API_URL not set',
        () {
          final url = AppEnvironment.production.apiBaseUrl;
          expect(url, 'https://api.example.com');
        },
      );

      test('returns non-empty URL for all environments', () {
        expect(AppEnvironment.development.apiBaseUrl.isNotEmpty, true);
        expect(AppEnvironment.staging.apiBaseUrl.isNotEmpty, true);
        expect(AppEnvironment.production.apiBaseUrl.isNotEmpty, true);
      });
    });

    group('webSocketUrl', () {
      test('converts HTTP to WS for development', () {
        final wsUrl = AppEnvironment.development.webSocketUrl;
        expect(wsUrl, 'ws://localhost:3000');
        expect(wsUrl.startsWith('ws://'), true);
      });

      test('converts HTTPS to WSS for staging', () {
        final wsUrl = AppEnvironment.staging.webSocketUrl;
        expect(wsUrl, 'wss://api-staging.example.com');
        expect(wsUrl.startsWith('wss://'), true);
      });

      test('converts HTTPS to WSS for production', () {
        final wsUrl = AppEnvironment.production.webSocketUrl;
        expect(wsUrl, 'wss://api.example.com');
        expect(wsUrl.startsWith('wss://'), true);
      });

      test('returns non-empty URL for all environments', () {
        expect(AppEnvironment.development.webSocketUrl.isNotEmpty, true);
        expect(AppEnvironment.staging.webSocketUrl.isNotEmpty, true);
        expect(AppEnvironment.production.webSocketUrl.isNotEmpty, true);
      });

      test('webSocketUrl matches apiBaseUrl protocol conversion', () {
        final devApi = AppEnvironment.development.apiBaseUrl;
        final devWs = AppEnvironment.development.webSocketUrl;
        expect(devWs, devApi.replaceFirst('http://', 'ws://'));

        final stagingApi = AppEnvironment.staging.apiBaseUrl;
        final stagingWs = AppEnvironment.staging.webSocketUrl;
        expect(stagingWs, stagingApi.replaceFirst('https://', 'wss://'));

        final prodApi = AppEnvironment.production.apiBaseUrl;
        final prodWs = AppEnvironment.production.webSocketUrl;
        expect(prodWs, prodApi.replaceFirst('https://', 'wss://'));
      });
    });

    group('displayName', () {
      test('returns capitalized name for development', () {
        expect(AppEnvironment.development.displayName, 'Development');
      });

      test('returns capitalized name for staging', () {
        expect(AppEnvironment.staging.displayName, 'Staging');
      });

      test('returns capitalized name for production', () {
        expect(AppEnvironment.production.displayName, 'Production');
      });

      test('first letter is uppercase', () {
        for (final env in AppEnvironment.values) {
          final displayName = env.displayName;
          expect(displayName.isNotEmpty, true);
          expect(displayName[0], displayName[0].toUpperCase());
        }
      });
    });

    group('toString', () {
      test('returns displayName for development', () {
        expect(AppEnvironment.development.toString(), 'Development');
        expect(
          AppEnvironment.development.toString(),
          AppEnvironment.development.displayName,
        );
      });

      test('returns displayName for staging', () {
        expect(AppEnvironment.staging.toString(), 'Staging');
        expect(
          AppEnvironment.staging.toString(),
          AppEnvironment.staging.displayName,
        );
      });

      test('returns displayName for production', () {
        expect(AppEnvironment.production.toString(), 'Production');
        expect(
          AppEnvironment.production.toString(),
          AppEnvironment.production.displayName,
        );
      });

      test('toString matches displayName for all environments', () {
        for (final env in AppEnvironment.values) {
          expect(env.toString(), env.displayName);
        }
      });
    });

    group('name property', () {
      test('development name is lowercase', () {
        expect(AppEnvironment.development.name, 'development');
      });

      test('staging name is lowercase', () {
        expect(AppEnvironment.staging.name, 'staging');
      });

      test('production name is lowercase', () {
        expect(AppEnvironment.production.name, 'production');
      });
    });

    group('equality', () {
      test('same enum values are equal', () {
        expect(AppEnvironment.development, AppEnvironment.development);
        expect(AppEnvironment.staging, AppEnvironment.staging);
        expect(AppEnvironment.production, AppEnvironment.production);
      });

      test('different enum values are not equal', () {
        expect(AppEnvironment.development, isNot(AppEnvironment.staging));
        expect(AppEnvironment.development, isNot(AppEnvironment.production));
        expect(AppEnvironment.staging, isNot(AppEnvironment.production));
      });
    });

    group('hashCode', () {
      test('same enum values have same hashCode', () {
        expect(
          AppEnvironment.development.hashCode,
          AppEnvironment.development.hashCode,
        );
        expect(
          AppEnvironment.staging.hashCode,
          AppEnvironment.staging.hashCode,
        );
        expect(
          AppEnvironment.production.hashCode,
          AppEnvironment.production.hashCode,
        );
      });
    });
  });
}
