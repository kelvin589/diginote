import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/providers/io_templates_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/widgets/message_item_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplatesViewPopup extends StatelessWidget {
  const TemplatesViewPopup({Key? key, required this.screenToken})
      : super(key: key);

  final String screenToken;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Insert Template"),
      content: Consumer<TemplatesProvider>(
        builder: (context, templatesProvider, child) {
          return FutureBuilder<List<Message>>(
            future: templatesProvider.readTemplates(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${(snapshot.error.toString())}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              Iterable<Message>? templates = snapshot.data;
              if (templates != null) {
                return GridView.count(
                  padding: const EdgeInsets.only(top: 16.0),
                  crossAxisCount: 2,
                  children: List.generate(templates.length, (index) {
                    return Center(
                      child: _TemplateItem(
                        template: templates.elementAt(index),
                        context: context,
                        screenToken: screenToken,
                      ),
                    );
                  }),
                );
              } else {
                return const Text('Error occurred');
              }
            },
          );
        },
      ),
      actions: [
        DialogueHelper.cancelButton(context),
      ],
    );
  }
}

class _TemplateItem extends StatelessWidget {
  const _TemplateItem(
      {Key? key,
      required this.template,
      required this.context,
      required this.screenToken})
      : super(key: key);

  final Message template;
  final BuildContext context;
  final String screenToken;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await insertTemplate(),
      child: MessageItemContent(
        message: template,
        width: template.width,
        height: template.height,
        selected: false,
      ),
    );
  }

  Future<void> insertTemplate() async {
    await Provider.of<FirebasePreviewProvider>(context, listen: false)
        .addMessage(screenToken, template);
    Navigator.pop(context);
  }
}
