import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/repositories/firebase_preview_repository.dart';
import 'package:flutter/material.dart';

class FirebasePreviewProvider extends ChangeNotifier {
  final FirebasePreviewRepository _previewRepository =
      FirebasePreviewRepository();

  Stream<Iterable<Message>> getMessages(String screenToken) {
    return _previewRepository.getMessages(screenToken);
  }

  void addMessage(String screenToken, Message message) {
    _previewRepository.addMessage(screenToken, message);
  }

  void updateMessageCoordinates(String screenToken, Message message) {
    _previewRepository.updateMessageCoordinates(screenToken, message);
  }

  void deleteMessage(String screenToken, Message message) {
    _previewRepository.deleteMessage(screenToken, message);
  }

  void updateMessageSchedule(
      String screenToken, Message message, DateTime from, DateTime to, bool scheduled) {
    _previewRepository.updateMessageSchedule(screenToken, message, from, to, scheduled);
  }
}
