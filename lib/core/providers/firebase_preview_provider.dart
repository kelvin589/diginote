import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/repositories/firebase_preview_repository.dart';
import 'package:flutter/material.dart';

class FirebasePreviewProvider extends ChangeNotifier {
  final FirebasePreviewRepository _previewRepository = FirebasePreviewRepository();

  Stream<Iterable<Message>> getMessages(String screenToken) {
    return _previewRepository.getMessages(screenToken);
  }
}
