import 'package:diginote/core/models/screen_pairing_model.dart';
import 'package:flutter_test/flutter_test.dart';

class ScreenPairingMatcher implements Matcher {
  final Map<String, dynamic>? _data;

  ScreenPairingMatcher(this._data);

  @override
  Description describe(Description description) {
    return StringDescription("Matches a screenPairing");
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    return mismatchDescription;
  }

  @override
  bool matches(item, Map matchState) {
    final screenPairing = item as ScreenPairing;
    return equals(screenPairing.toJson()).matches(_data, matchState);
  }
}