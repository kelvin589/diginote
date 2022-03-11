import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/io_templates_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TemplatesView extends StatelessWidget {
  const TemplatesView({Key? key}) : super(key: key);

  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    // final id = uuid.v4();
    const id = "some-unique-id";
    final testMessage = Message(
        header: "header",
        message: "message",
        x: 0,
        y: 0,
        id: id,
        from: DateTime.now(),
        to: DateTime.now(),
        scheduled: false,
        fontFamily: "Roboto",
        fontSize: 12,
        backgrondColour: 0,
        foregroundColour: 0,
        width: 100,
        height: 100);

    return Consumer<TemplatesProvider>(
      builder: (context, templatesProvider, child) {
        return Column(
          children: [
            const Text("Templates view"),
            ElevatedButton(
              onPressed: () async =>
                  await templatesProvider.addTemplate(testMessage),
              child: const Text("Add"),
            ),
            ElevatedButton(
              onPressed: () async => await templatesProvider.deleteTemplate(testMessage.id),
              child: const Text("Delete"),
            ),
            ElevatedButton(
              onPressed: () async => await templatesProvider.printAllFiles(),
              child: const Text("Print All"),
            ),
          ],
        );
      },
    );
  }
}
