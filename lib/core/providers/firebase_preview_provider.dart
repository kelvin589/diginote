import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/repositories/firebase_preview_repository.dart';
import 'package:flutter/material.dart';

/// A provider using the [FirebasePreviewRepository].
/// 
/// Manages the preview view to display, add, delete and edit messages.
class FirebasePreviewProvider extends ChangeNotifier {
  /// The [FirebasePreviewRepository] instance.
  final FirebasePreviewRepository _previewRepository;

  /// Initialises the [FirebasePreviewRepository].
  FirebasePreviewProvider({required FirebaseFirestore firestoreInstance })
    : _previewRepository = FirebasePreviewRepository(firestoreInstance: firestoreInstance);

  /// Retrieves a stream of [Message]s from Firebase, for screen with [screenToken].
  Stream<Iterable<Message>> getMessages(String screenToken) {
    return _previewRepository.getMessages(screenToken);
  }

  /// Inserts a new [Message] into Firebase for the screen with [screenToken].
  Future<void> addMessage(String screenToken, Message message) async {
    await _previewRepository.addMessage(screenToken, message);
  }

  /// Update an existing [Message] for screen with [screenToken].
  Future<void> updateMessage(String screenToken, Message message) async {
    await _previewRepository.updateMessage(screenToken, message);
  }

  /// Updates the coordinates of the [message] for [screenToken].
  Future<void> updateMessageCoordinates(String screenToken, Message message) async {
    await _previewRepository.updateMessageCoordinates(screenToken, message);
  }

  /// Deletes the [message] for the screen with [screenToken].
  Future<void> deleteMessage(String screenToken, Message message) async {
    await _previewRepository.deleteMessage(screenToken, message);
  }

  /// Updates the scheduling for the [message] for the screen with [screenToken].
  Future<void> updateMessageSchedule(
      String screenToken, Message message, DateTime from, DateTime to, bool scheduled) async {
    await _previewRepository.updateMessageSchedule(screenToken, message, from, to, scheduled);
  }
}
