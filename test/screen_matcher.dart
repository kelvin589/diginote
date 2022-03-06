import 'package:diginote/core/models/screen_model.dart';
import 'package:flutter_test/flutter_test.dart';

class ScreenMatcher implements Matcher {
  final Map<String, dynamic>? _data;

  ScreenMatcher(this._data);

  @override
  Description describe(Description description) {
    return StringDescription("Matches a screen");
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    return mismatchDescription;
  }

  @override
  bool matches(item, Map matchState) {
    final screen = item as Screen;
    return equals(screen.toJson()).matches(_data, matchState);
  }
}