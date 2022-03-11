import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/io_templates_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/add_template_popup.dart';
import 'package:diginote/ui/widgets/message_item_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TemplatesView extends StatelessWidget {
  const TemplatesView({Key? key}) : super(key: key);

  final uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplatesProvider>(
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
                    child: _TemplateItem(template: templates.elementAt(index)),
                  );
                }),
              );
            } else {
              return const Text('Error occurred');
            }
          },
        );
      },
    );
  }
}

class _TemplateItem extends StatefulWidget {
  const _TemplateItem({Key? key, required this.template}) : super(key: key);

  final Message template;

  @override
  State<_TemplateItem> createState() => _TemplateItemState();
}

class _TemplateItemState extends State<_TemplateItem> {
  bool displayOptions = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayOptions
            ? _OptionsPanel(template: widget.template, onDelete: onDelete)
            : Container(),
        GestureDetector(
          onTap: toggleDisplayOptions,
          child: MessageItemContent(
            message: widget.template,
            width: widget.template.width,
            height: widget.template.height,
            selected: false,
          ),
        ),
      ],
    );
  }

  Future<void> onDelete() async {
    setDisplayOptions(false);
    await Provider.of<TemplatesProvider>(context, listen: false)
        .deleteTemplate(widget.template.id);
  }

  void toggleDisplayOptions() {
    setState(() {
      displayOptions = !displayOptions;
    });
  }

  void setDisplayOptions(bool newValue) {
    setState(() {
      displayOptions = newValue;
    });
  }
}

class _OptionsPanel extends StatelessWidget {
  const _OptionsPanel(
      {Key? key, required this.template, required this.onDelete})
      : super(key: key);

  final Message template;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async {
            DialogueHelper.showDestructiveDialogue(
              context: context,
              title: "Delete Template",
              message: 'Are you sure you want to delete this template?',
              onConfirm: () async {
                await onDelete();
              },
            );
          },
          icon: IconHelper.deleteIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddTemplatePopup(
              template: template,
            ),
          ),
          icon: IconHelper.editIcon,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
