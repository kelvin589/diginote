import 'package:diginote/core/models/screen_info_model.dart';
import 'package:flutter_test/flutter_test.dart';

class ScreenInfoMatcher implements Matcher {
  final Map<String, dynamic>? _data;

  ScreenInfoMatcher(this._data);

  @override
  Description describe(Description description) {
    return StringDescription("Matches screen info");
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    return mismatchDescription;
  }

  @override
  bool matches(item, Map matchState) {
    final screen = item as ScreenInfo;
    return equals(screen.toJson()).matches(_data, matchState);
  }
}