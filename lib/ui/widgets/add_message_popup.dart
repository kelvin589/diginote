import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;

class AddMessagePopup extends StatefulWidget {
  const AddMessagePopup({Key? key, required this.screenToken, this.message})
      : super(key: key);

  final String screenToken;
  // If message is not null, it means we are editing
  final Message? message;

  @override
  _AddMessagePopupState createState() => _AddMessagePopupState();
}

class _AddMessagePopupState extends State<AddMessagePopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _headerController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

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
    if (widget.message != null) {
      _headerController.text = widget.message!.header;
      _messageController.text = widget.message!.message;
      fontFamily = widget.message!.fontFamily;
      fontSize = widget.message!.fontSize;
      backgroundColour = Color(widget.message!.backgrondColour);
      foregroundColour = Color(widget.message!.foregroundColour);
      width = widget.message!.width;
      height = widget.message!.height;
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
        initialFontFamily: widget.message?.fontFamily,
        initialFontSize: widget.message?.fontSize,
      ),
      ForegroundColourSelector(
        onColourChanged: onForegroundColourChanged,
        initialColour: widget.message != null
            ? Color(widget.message!.foregroundColour)
            : null,
      ),
      BackgroundColourSelector(
        onColourChanged: onBackgroundColourChanged,
        initialColour: widget.message != null
            ? Color(widget.message!.backgrondColour)
            : null,
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
        title: widget.message == null
            ? const Text('Add Message')
            : const Text('Save Message'),
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
    // TODO: Implement X/Y
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
        height: height);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await Provider.of<FirebasePreviewProvider>(context, listen: false)
          .addMessage(widget.screenToken, newMessage);
      Navigator.pop(context);
    }
  }

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
        height: height);
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
