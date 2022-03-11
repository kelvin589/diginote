import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:uuid/uuid.dart';

class TemplatesProvider extends ChangeNotifier {
  final directoryName = "messages";

  // Must call init after creating provider
  Future<void> init() async {
    final path = await _localPath;
    final directory = Directory('$path/$directoryName');

    if (await directory.exists()) {
      print("Exists");
    } else {
      print("Doesn't exist so creating path");
      await directory.create();
      await _addDefaultTemplates();
    }
  }

  Future<void> _addDefaultTemplates() async {
    final uuid = Uuid();
    Message doNotDisturb = Message(
        header: "",
        message: "Do Not Disturb",
        x: 0,
        y: 0,
        id: uuid.v4(),
        from: clock.now(),
        to: clock.now(),
        scheduled: false,
        fontFamily: "Roboto",
        fontSize: 48.0,
        backgrondColour: 4294702838,
        foregroundColour: 4294902531,
        width: 200.0,
        height: 200.0);
    await addTemplate(doNotDisturb);
  }

  // Get path to documents directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Get a single file with id
  Future<File> _localFile(String id) async {
    final path = await _localPath;

    return File('$path/$directoryName/$id.txt');
  }

  // Get all the files in directory
  Future<List<File>> get _localDirectoryFiles async {
    final path = await _localPath;
    final dir = Directory('$path/$directoryName');
    final entities = await dir.list().toList();

    return entities.whereType<File>().toList();
  }

  // Add or update if it exists
  Future<File> addTemplate(Message message) async {
    final file = await _localFile(message.id);
    notifyListeners();

    return file.writeAsString(jsonEncode(message.toJsonWithIDAndISO()));
  }

  Future<bool> deleteTemplate(String id) async {
    final file = await _localFile(id);

    if (await file.exists()) {
      print("File exists so delete it");
      await file.delete();
      notifyListeners();
      return true;
    }

    print("Couldn't delete the file");
    return false;
  }

  Future<List<Message>> readTemplates() async {
    try {
      final List<File> files = await _localDirectoryFiles;
      final List<Message> messages = [];

      for (File file in files) {
        final contents = await file.readAsString();
        final Map<String, Object?> map = jsonDecode(contents);
        final Message message = Message.fromJsonWithIDAndISO(map);
        messages.add(message);
      }

      return messages;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> printAllFiles() async {
    final files = await _localDirectoryFiles;

    files.forEach((file) async => print(await file.readAsString()));
  }

  Future<void> deleteAll() async {
    final files = await _localDirectoryFiles;

    files.forEach((file) async => await file.delete());
    notifyListeners();
  }
}
