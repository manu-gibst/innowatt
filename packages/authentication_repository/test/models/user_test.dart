import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    const id = 'mock-id';
    const email = 'mock-email';

    test('uses value equality', () {
      expect(
        User(email: email, id: id),
        equals(User(id: id, email: email)),
      );
    });
  });
}
