import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/features/auth/infrastructure/models/websocket/auth_ws_event_model.dart';

import '../../../../../helpers/test_data.dart';

void main() {
  group('AuthWsEventModel', () {
    const tUser = TestData.userModel;

    test('fromJson creates model correctly', () {
      final json = {
        'event': 'user_authenticated',
        'data': tUser.toJson(),
        'timestamp': '2023-01-01T12:00:00.000Z',
      };

      final model = AuthWsEventModel.fromJson(json);

      expect(model.event, 'user_authenticated');
      expect(model.data, tUser);
      expect(model.timestamp, DateTime.utc(2023, 1, 1, 12));
    });

    group('AuthWsEventTypeX', () {
      test('isAuthenticated returns true for auth events', () {
        const model1 = AuthWsEventModel(event: 'user_authenticated');
        const model2 = AuthWsEventModel(event: 'user_updated');

        expect(model1.isAuthenticated, true);
        expect(model2.isAuthenticated, true);
      });

      test('isLoggedOut returns true for logout events', () {
        const model1 = AuthWsEventModel(event: 'user_logged_out');
        const model2 = AuthWsEventModel(event: 'session_expired');

        expect(model1.isLoggedOut, true);
        expect(model2.isLoggedOut, true);
      });

      test('isUpdated returns true for update events', () {
        const model = AuthWsEventModel(event: 'user_updated');

        expect(model.isUpdated, true);
      });
    });

    group('toJson', () {
      test('converts model to JSON with all fields', () {
        final timestamp = DateTime.utc(2023, 1, 1, 12);
        final model = AuthWsEventModel(
          event: 'user_authenticated',
          data: tUser,
          timestamp: timestamp,
        );

        final json = model.toJson();

        expect(json['event'], 'user_authenticated');
        expect(json['data'], isNotNull);
        expect(json['timestamp'], '2023-01-01T12:00:00.000Z');
      });

      test('converts model to JSON with null data and timestamp', () {
        const model = AuthWsEventModel(event: 'user_logged_out');

        final json = model.toJson();

        expect(json['event'], 'user_logged_out');
        expect(json['data'], isNull);
        expect(json['timestamp'], isNull);
      });
    });
  });
}
