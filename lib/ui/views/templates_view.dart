import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/models/templates_model.dart';
import 'package:diginote/core/providers/firebase_templates_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/widgets/add_template_popup.dart';
import 'package:diginote/ui/widgets/message_item_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays the user's list of templates.
///
/// From here, the user can insert new templates and update or delete existing ones.
class TemplatesView extends StatelessWidget {
  const TemplatesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseTemplatesProvider>(
      builder: (context, templatesProvider, child) {
        return StreamBuilder<Iterable<Template>>(
          stream: templatesProvider.readTemplates(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error ${(snapshot.error.toString())}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            Iterable<Template>? templates = snapshot.data;
            // Generates a list of TemplateItems to display the user's templates.
            if (templates != null) {
              return Scrollbar(
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 1.4,
                  shrinkWrap: true,
                  children: List.generate(
                    templates.length,
                    (index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TemplateItem(
                            template: templates.elementAt(index),
                          ),
                        ],
                      );
                    },
                  ),
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

/// Displays an individual [Template] item, which additionally
/// displays its [_TemplateOptionsPanel] when tapped.
class _TemplateItem extends StatefulWidget {
  /// Creates a [TemplateItem] which displays the [template].
  const _TemplateItem({Key? key, required this.template}) : super(key: key);

  /// The [Template] to display.
  final Template template;

  @override
  State<_TemplateItem> createState() => _TemplateItemState();
}

class _TemplateItemState extends State<_TemplateItem> {
  /// Whether or not the [_TemplateOptionsPanel] should be displayed.
  bool displayOptions = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        displayOptions
            ? _TemplateOptionsPanel(
                template: widget.template, onDelete: onDelete)
            : Container(),
        GestureDetector(
          onTap: toggleDisplayOptions,
          // Reuses MessageItemContent to display the template.
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
              height: widget.template.height,
              textAlignment: widget.template.textAlignment,
            ),
            width: widget.template.width,
            height: widget.template.height,
            selected: false,
          ),
        ),
      ],
    );
  }

  /// Called when a template is deleted.
  Future<void> onDelete() async {
    // Need to close the options panel before deleting to prevent UI bugs.
    setDisplayOptions(false);
    await Provider.of<FirebaseTemplatesProvider>(context, listen: false)
        .deleteTemplate(widget.template.id);
  }

  /// Toggles displaying the options panel.
  void toggleDisplayOptions() {
    setState(() {
      displayOptions = !displayOptions;
    });
  }

  /// Sets the [displayOptions], rather than toggling.
  void setDisplayOptions(bool newValue) {
    setState(() {
      displayOptions = newValue;
    });
  }
}

/// The options panel displayed when a template is tapped,
/// to edit or delete a template.
class _TemplateOptionsPanel extends StatelessWidget {
  const _TemplateOptionsPanel({
    Key? key,
    required this.template,
    required this.onDelete,
  }) : super(key: key);

  /// The template to edit or delete.
  final Template template;

  /// Called when 'Delete' is pressed.
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
