import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/models/templates_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/core/services/io_templates_provider.dart';
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
          return FutureBuilder<List<Template>>(
            future: templatesProvider.readTemplates(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error ${(snapshot.error.toString())}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              Iterable<Template>? templates = snapshot.data;
              if (templates != null) {
                return Scrollbar(
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 1.1,
                    shrinkWrap: true,
                    children: List.generate(templates.length, (index) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _TemplateItem(
                              template: templates.elementAt(index),
                              context: context,
                              screenToken: screenToken,
                            ),
                          ]);
                    }),
                  ),
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

  final Template template;
  final BuildContext context;
  final String screenToken;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await insertTemplate(),
      child: MessageItemContent(
        message: Message(
            header: template.header,
            message: template.message,
            x: 0,
            y: 0,
            id: template.id,
            from: clock.now(),
            to: clock.now(),
            scheduled: false,
            fontFamily: template.fontFamily,
            fontSize: template.fontSize,
            backgrondColour: template.backgrondColour,
            foregroundColour: template.foregroundColour,
            width: template.width,
            height: template.height),
        width: template.width,
        height: template.height,
        selected: false,
      ),
    );
  }

  Future<void> insertTemplate() async {
    await Provider.of<FirebasePreviewProvider>(context, listen: false)
        .addMessage(
      screenToken,
      Message(
          header: template.header,
          message: template.message,
          x: 0,
          y: 0,
          id: template.id,
          from: clock.now(),
          to: clock.now(),
          scheduled: false,
          fontFamily: template.fontFamily,
          fontSize: template.fontSize,
          backgrondColour: template.backgrondColour,
          foregroundColour: template.foregroundColour,
          width: template.width,
          height: template.height),
    );
    Navigator.pop(context);
  }
}
