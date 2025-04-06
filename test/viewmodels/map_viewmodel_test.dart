import 'package:flutter_test/flutter_test.dart';
import 'package:friends_around_me/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('MapViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
