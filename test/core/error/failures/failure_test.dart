import 'package:flutter_test/flutter_test.dart';
import 'package:starter_app/core/error/failures/failure.dart';

class TestFailure extends Failure {
  const TestFailure();

  @override
  String get message => 'Test message';

  @override
  bool get isRetryable => false;
}

void main() {
  group('Failure', () {
    test('default stackTrace is null', () {
      const failure = TestFailure();
      expect(failure.stackTrace, isNull);
    });
  });
}
