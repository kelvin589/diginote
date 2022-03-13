import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/io_templates_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/widgets/message_options/background_colour_selector.dart';
import 'package:diginote/ui/widgets/message_options/font_selector.dart';
import 'package:diginote/ui/widgets/message_options/foreground_colour_selector.dart';
import 'package:diginote/ui/widgets/message_options/header_input.dart';
import 'package:diginote/ui/widgets/message_options/listing_selector.dart';
import 'package:diginote/ui/widgets/message_options/message_input.dart';
import 'package:diginote/ui/widgets/message_options/message_size_selector.dart';
import 'package:diginote/ui/widgets/message_options/text_alignment_selector.dart';
import 'package:diginote/ui/widgets/message_options/typeface_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddTemplatePopup extends StatefulWidget {
  const AddTemplatePopup({Key? key, this.template}) : super(key: key);

  // If template is not null, it means we are editing
  final Message? template;

  @override
  _AddTemplatePopupState createState() => _AddTemplatePopupState();
}

class _AddTemplatePopupState extends State<AddTemplatePopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final uuid = const Uuid();

  String fontFamily = "Roboto";
  double fontSize = 16.0;
  Color backgroundColour = Colors.yellow;
  Color foregroundColour = Colors.black;
  double width = 100;
  double height = 100;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _headerController.text = widget.template!.header;
      _messageController.text = widget.template!.message;
      fontFamily = widget.template!.fontFamily;
      fontSize = widget.template!.fontSize;
      backgroundColour = Color(widget.template!.backgrondColour);
      foregroundColour = Color(widget.template!.foregroundColour);
      width = widget.template!.width;
      height = widget.template!.height;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget messageBodyAndHeader = Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderInput(
                  headerController: _headerController,
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                  backgroundColour: backgroundColour,
                  foregroundColour: foregroundColour,
                  width: width,
                  height: height,
                ),
                MessageInput(
                  messageController: _messageController,
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                  backgroundColour: backgroundColour,
                  foregroundColour: foregroundColour,
                  width: width,
                  height: height,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    List<Widget> formOptions = [
      MessageSizeSelector(
        currentWidth: width,
        currentHeight: height,
        onMessageSizeChanged: (width, height) {
          setState(() {
            this.width = width;
            this.height = height;
          });
        },
      ),
      const TypefaceSelector(),
      FontSelector(
        onFontFamilyChanged: onFontFamilyChanged,
        onFontSizeChanged: onFontSizeChanged,
        initialFontFamily: widget.template?.fontFamily ?? fontFamily,
        initialFontSize: widget.template?.fontSize ?? fontSize,
      ),
      ForegroundColourSelector(
        onColourChanged: onForegroundColourChanged,
        initialColour: widget.template != null
            ? Color(widget.template!.foregroundColour)
            : foregroundColour,
      ),
      BackgroundColourSelector(
        onColourChanged: onBackgroundColourChanged,
        initialColour: widget.template != null
            ? Color(widget.template!.backgrondColour)
            : backgroundColour,
      ),
      const ListingSelector(),
      const TextAlignmentSelector(),
    ];

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: AlertDialog(
        title: widget.template == null
            ? const Text('Add Template')
            : const Text('Save Template'),
        insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 50.0),
        contentPadding: const EdgeInsets.all(16.0),
        content: Form(
          key: _formKey,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: messageBodyAndHeader,
                ),
              ),
              Expanded(
                child: Container(
                  width: kIsWeb ? 400 : double.maxFinite,
                  child: Scrollbar(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: formOptions.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.transparent,
                      ),
                      itemBuilder: (context, index) => formOptions[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          DialogueHelper.cancelButton(context),
          widget.template == null
              ? DialogueHelper.okButton(isLoading
                  ? null
                  : () async {
                      await _okPressed();
                    })
              : DialogueHelper.saveButton(isLoading
                  ? null
                  : () async {
                      DialogueHelper.showConfirmationDialogue(
                          context: context,
                          title: "Save Template",
                          message:
                              "Are you sure you want to save this edited template?",
                          confirmationActionText: "Save",
                          onConfirm: () async {
                            await _savePressed();
                          });
                    }),
        ],
      ),
    );
  }

  void onFontFamilyChanged(String fontFamily) {
    setState(() {
      this.fontFamily = fontFamily;
    });
  }

  void onFontSizeChanged(double fontSize) {
    setState(() {
      this.fontSize = fontSize;
    });
  }

  void onForegroundColourChanged(Color newColour) {
    setState(() => foregroundColour = newColour);
  }

  void onBackgroundColourChanged(Color newColour) {
    setState(() => backgroundColour = newColour);
  }

  Future<void> _okPressed() async {
    Message newTemplate = Message(
        header: _headerController.text,
        message: _messageController.text,
        x: 0,
        y: 0,
        id: uuid.v4(),
        from: clock.now(),
        to: clock.now(),
        scheduled: false,
        fontFamily: fontFamily,
        fontSize: fontSize,
        backgrondColour: backgroundColour.value,
        foregroundColour: foregroundColour.value,
        width: width,
        height: height);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<TemplatesProvider>(context, listen: false)
          .addTemplate(newTemplate);
      Navigator.pop(context);
    }
  }

  Future<void> _savePressed() async {
    Message newTemplate = Message(
        header: _headerController.text,
        message: _messageController.text,
        x: widget.template!.x,
        y: widget.template!.y,
        id: widget.template!.id,
        from: widget.template!.from,
        to: widget.template!.to,
        scheduled: widget.template!.scheduled,
        fontFamily: fontFamily,
        fontSize: fontSize,
        backgrondColour: backgroundColour.value,
        foregroundColour: foregroundColour.value,
        width: width,
        height: height);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<TemplatesProvider>(context, listen: false)
          .addTemplate(newTemplate);
      Navigator.pop(context);
    }
  }
}
