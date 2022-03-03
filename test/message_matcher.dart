import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter_test/flutter_test.dart';

class MessageMatcher implements Matcher {
  final Map<String, dynamic> _data;

  MessageMatcher(this._data);

  @override
  Description describe(Description description) {
    return StringDescription("Matches a Message");
  }

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    return mismatchDescription;
  }

  @override
  bool matches(item, Map matchState) {
    final message = item as Message;
    return equals(message.toJson()).matches(_data, matchState);
  }
}