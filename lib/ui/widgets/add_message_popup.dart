import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/widgets/message_options/background_colour_selector.dart';
import 'package:diginote/ui/widgets/message_options/font_selector.dart';
import 'package:diginote/ui/widgets/message_options/foreground_colour_selector.dart';
import 'package:diginote/ui/widgets/message_options/header_input.dart';
import 'package:diginote/ui/widgets/message_options/message_input.dart';
import 'package:diginote/ui/widgets/message_options/message_size_selector.dart';
import 'package:diginote/ui/widgets/message_options/text_alignment_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// An [AlertDialog] for creating or editing a message with
/// various message customisations.
class AddMessagePopup extends StatefulWidget {
  /// [message] is optional to enable reuse of this popup for editing and creating.
  const AddMessagePopup({
    Key? key,
    required this.screenToken,
    this.message,
  }) : super(key: key);

  /// The screen token.
  final String screenToken;

  /// The message to edit.
  ///
  /// If [message] is not null, it means we are editing.
  final Message? message;

  @override
  _AddMessagePopupState createState() => _AddMessagePopupState();
}

class _AddMessagePopupState extends State<AddMessagePopup> {
  /// The [GlobalKey] for this form.
  final _formKey = GlobalKey<FormState>();

  /// The [TextEditingController] for the header input.
  final TextEditingController _headerController = TextEditingController();

  /// The [TextEditingController] for the message input.
  final TextEditingController _messageController = TextEditingController();

  /// The currently selected font family.
  String fontFamily = "Roboto";

  /// The currently selected font size.
  double fontSize = 16.0;

  /// The currently selected background colour.
  Color backgroundColour = const Color.fromARGB(255, 255, 255, 153);

  /// The currently selected foreground colour.
  Color foregroundColour = Colors.black;

  /// The currently selected width.
  double width = 100;

  /// The currently selected height.
  double height = 100;

  /// The currently selected text aligment.
  TextAlign textAlignment = TextAlign.left;

  /// [isLoading] is true if we are waiting to save or add the message.
  bool isLoading = false;

  /// [initState] initialises the above fields if we are editing a message.
  @override
  void initState() {
    super.initState();
    if (widget.message != null) {
      _headerController.text = widget.message!.header;
      _messageController.text = widget.message!.message;
      fontFamily = widget.message!.fontFamily;
      fontSize = widget.message!.fontSize;
      backgroundColour = Color(widget.message!.backgrondColour);
      foregroundColour = Color(widget.message!.foregroundColour);
      width = widget.message!.width;
      height = widget.message!.height;
      textAlignment = TextAlign.values.byName(widget.message!.textAlignment);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget messageBodyAndHeader = SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: HeaderInput(
              headerController: _headerController,
              fontFamily: fontFamily,
              fontSize: fontSize,
              backgroundColour: backgroundColour,
              foregroundColour: foregroundColour,
              width: width,
              height: height,
              textAlign: textAlignment,
            ),
          ),
          Expanded(
            flex: 3,
            child: MessageInput(
              messageController: _messageController,
              fontFamily: fontFamily,
              fontSize: fontSize,
              backgroundColour: backgroundColour,
              foregroundColour: foregroundColour,
              width: width,
              height: height,
              textAlign: textAlignment,
            ),
          ),
        ],
      ),
    );

    /// The customisation options displayed in the alert.
    List<Widget> formOptions = [
      MessageSizeSelector(
        currentWidth: width,
        currentHeight: height,
        onMessageSizeChanged: onMessageSizeChanged,
      ),
      FontSelector(
        onFontFamilyChanged: onFontFamilyChanged,
        onFontSizeChanged: onFontSizeChanged,
        initialFontFamily: fontFamily,
        initialFontSize: fontSize,
      ),
      ForegroundColourSelector(
        onColourChanged: onForegroundColourChanged,
        initialColour: foregroundColour,
      ),
      BackgroundColourSelector(
        onColourChanged: onBackgroundColourChanged,
        initialColour: backgroundColour,
      ),
      TextAlignmentSelector(
        onTextAlignmentChanged: onTextAlignmentChanged,
        initialTextAlignment: textAlignment,
      ),
    ];

    return GestureDetector(
      // Tap away from the keyboard to remove focus.
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: AlertDialog(
        title: widget.message == null
            ? const Text('Add Message')
            : const Text('Save Message'),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 50.0,
        ),
        contentPadding: const EdgeInsets.all(8.0),
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
                child: SizedBox(
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
          widget.message == null
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
                          title: "Save Message",
                          message:
                              "Are you sure you want to save this edited message?",
                          confirmationActionText: "Save",
                          onConfirm: () async {
                            await _savePressed();
                          });
                    }),
        ],
      ),
    );
  }

  /// Called when the message size is changed.
  void onMessageSizeChanged(double width, double height) {
    setState(() {
      this.width = width;
      this.height = height;
    });
  }

  /// Called when the font family is changed.
  void onFontFamilyChanged(String fontFamily) {
    setState(() => this.fontFamily = fontFamily);
  }

  /// Called when the font size is changed.
  void onFontSizeChanged(double fontSize) {
    setState(() => this.fontSize = fontSize);
  }

  /// Called when the foreground colour is changed.
  void onForegroundColourChanged(Color newColour) {
    setState(() => foregroundColour = newColour);
  }

  /// Called when the background colour is changed.
  void onBackgroundColourChanged(Color newColour) {
    setState(() => backgroundColour = newColour);
  }

  /// Called when the text alignment is changed.
  void onTextAlignmentChanged(TextAlign newTextAlignment) {
    setState(() => textAlignment = newTextAlignment);
  }

  /// Called when 'OK' is pressed.
  Future<void> _okPressed() async {
    Message newMessage = Message(
        header: _headerController.text,
        message: _messageController.text,
        x: 0,
        y: 0,
        id: "",
        from: clock.now(),
        to: clock.now(),
        scheduled: false,
        fontFamily: fontFamily,
        fontSize: fontSize,
        backgrondColour: backgroundColour.value,
        foregroundColour: foregroundColour.value,
        width: width,
        height: height,
        textAlignment: textAlignment.name);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<FirebasePreviewProvider>(context, listen: false)
          .addMessage(widget.screenToken, newMessage);
      Navigator.pop(context);
    }
  }

  /// Called instead if 'Save' is pressed.
  Future<void> _savePressed() async {
    Message newMessage = Message(
        header: _headerController.text,
        message: _messageController.text,
        x: widget.message!.x,
        y: widget.message!.y,
        id: widget.message!.id,
        from: widget.message!.from,
        to: widget.message!.to,
        scheduled: widget.message!.scheduled,
        fontFamily: fontFamily,
        fontSize: fontSize,
        backgrondColour: backgroundColour.value,
        foregroundColour: foregroundColour.value,
        width: width,
        height: height,
        textAlignment: textAlignment.name);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<FirebasePreviewProvider>(context, listen: false)
          .updateMessage(widget.screenToken, newMessage);
      Navigator.pop(context);
    }
  }
}
