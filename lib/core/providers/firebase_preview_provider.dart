import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/repositories/firebase_preview_repository.dart';
import 'package:flutter/material.dart';

class FirebasePreviewProvider extends ChangeNotifier {
  final FirebasePreviewRepository _previewRepository;

  FirebasePreviewProvider({required FirebaseFirestore firestoreInstance })
    : _previewRepository = FirebasePreviewRepository(firestoreInstance: firestoreInstance);

  Stream<Iterable<Message>> getMessages(String screenToken) {
    return _previewRepository.getMessages(screenToken);
  }

  Future<void> addMessage(String screenToken, Message message) async {
    await _previewRepository.addMessage(screenToken, message);
  }

  Future<void> updateMessageCoordinates(String screenToken, Message message) async {
    await _previewRepository.updateMessageCoordinates(screenToken, message);
  }

  Future<void> deleteMessage(String screenToken, Message message) async {
    await _previewRepository.deleteMessage(screenToken, message);
  }

  Future<void> updateMessageSchedule(
      String screenToken, Message message, DateTime from, DateTime to, bool scheduled) async {
    await _previewRepository.updateMessageSchedule(screenToken, message, from, to, scheduled);
  }
}
