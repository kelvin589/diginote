import 'package:diginote/core/models/templates_model.dart';
import 'package:flutter_test/flutter_test.dart';

class TemplateMatcher implements Matcher {
  final Map<String, dynamic>? _data;

  TemplateMatcher(this._data);

  @override
  Description describe(Description description) {
    return StringDescription("Matches a template");
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    return mismatchDescription;
  }

  @override
  bool matches(item, Map matchState) {
    final screen = item as Template;
    return equals(screen.toJson()).matches(_data, matchState);
  }
}