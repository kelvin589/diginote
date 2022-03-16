import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/models/templates_model.dart';
import 'package:diginote/core/services/io_templates_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/add_template_popup.dart';
import 'package:diginote/ui/widgets/message_item_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplatesView extends StatelessWidget {
  const TemplatesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplatesProvider>(
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
                  childAspectRatio: 1.4,
                  shrinkWrap: true,
                  children: List.generate(templates.length, (index) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TemplateItem(
                            template: templates.elementAt(index),
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
    );
  }
}

class _TemplateItem extends StatefulWidget {
  const _TemplateItem({Key? key, required this.template}) : super(key: key);

  final Template template;

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
            message: Message(
                header: widget.template.header,
                message: widget.template.message,
                x: 0,
                y: 0,
                id: widget.template.id,
                from: clock.now(),
                to: clock.now(),
                scheduled: false,
                fontFamily: widget.template.fontFamily,
                fontSize: widget.template.fontSize,
                backgrondColour: widget.template.backgrondColour,
                foregroundColour: widget.template.foregroundColour,
                width: widget.template.width,
                height: widget.template.height),
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

  final Template template;
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
