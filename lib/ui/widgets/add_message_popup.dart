import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:clock/clock.dart';
import 'package:diginote/core/models/messages_model.dart';
import 'package:diginote/core/providers/firebase_preview_provider.dart';
import 'package:diginote/ui/shared/dialogue_helper.dart';
import 'package:diginote/ui/shared/icon_helper.dart';
import 'package:diginote/ui/shared/input_validators.dart';
import 'package:diginote/ui/widgets/colour_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'font_picker.dart';

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
    List<Widget> formOptions = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeaderInput(
                  headerController: _headerController,
                  fontFamily: fontFamily,
                  fontSize: fontSize,
                  backgroundColour: backgroundColour,
                  foregroundColour: foregroundColour,
                  width: width,
                  height: height,
                ),
                _MessageInput(
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
      _MessageSizeInput(
        currentWidth: width,
        currentHeight: height,
        onMessageSizeChanged: (width, height) {
          setState(() {
            this.width = width;
            this.height = height;
          });
        },
      ),
      const _TypefaceSelector(),
      _FontSelector(
        onFontFamilyChanged: onFontFamilyChanged,
        onFontSizeChanged: onFontSizeChanged,
        initialFontFamily: widget.message?.fontFamily ?? null,
        initialFontSize: widget.message?.fontSize ?? null,
      ),
      _ForegroundColour(onColourChanged: onForegroundColourChanged),
      _BackgroundColour(
        onColourChanged: onBackgroundColourChanged,
      ),
      const _ListingSelector(),
      const _TextAlignmentSelector(),
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
        content: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              itemCount: formOptions.length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.transparent,
              ),
              itemBuilder: (context, index) => formOptions[index],
            ),
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

class _HeaderInput extends StatelessWidget {
  const _HeaderInput(
      {Key? key,
      required this.headerController,
      required this.fontFamily,
      required this.fontSize,
      required this.backgroundColour,
      required this.foregroundColour,
      required this.width,
      required this.height})
      : super(key: key);

  final TextEditingController headerController;
  final String fontFamily;
  final double fontSize;
  final Color backgroundColour;
  final Color foregroundColour;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height * 0.25,
      child: AutoSizeTextField(
        maxLines: 1,
        controller: headerController,
        decoration: InputDecoration(
          hintText: 'Header',
          fillColor: backgroundColour,
          filled: true,
          border: InputBorder.none,
        ),
        style: GoogleFonts.getFont(fontFamily,
            fontSize: fontSize, color: foregroundColour),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput(
      {Key? key,
      required this.messageController,
      required this.fontFamily,
      required this.fontSize,
      required this.backgroundColour,
      required this.foregroundColour,
      required this.width,
      required this.height})
      : super(key: key);

  final TextEditingController messageController;
  final String fontFamily;
  final double fontSize;
  final Color backgroundColour;
  final Color foregroundColour;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height * 0.75,
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        controller: messageController,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          hintText: 'Message',
          fillColor: backgroundColour,
          filled: true,
          border: InputBorder.none,
        ),
        validator: Validator.isEmpty,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: GoogleFonts.getFont(fontFamily,
            fontSize: fontSize, color: foregroundColour),
      ),
    );
  }
}

class _MessageSizeInput extends StatelessWidget {
  const _MessageSizeInput(
      {Key? key,
      required this.onMessageSizeChanged,
      required this.currentWidth,
      required this.currentHeight})
      : super(key: key);

  final Function(double, double) onMessageSizeChanged;
  final double currentWidth;
  final double currentHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Message Size"),
        Row(
          children: [
            TextButton(
              onPressed: () => onMessageSizeChanged(100, 100),
              child: Text(
                "Small",
                style: TextStyle(
                    color: (currentWidth != 100) ? Colors.black : Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => onMessageSizeChanged(150, 150),
              child: Text(
                "Medium",
                style: TextStyle(
                    color: (currentWidth != 150) ? Colors.black : Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => onMessageSizeChanged(200, 200),
              child: Text(
                "Large",
                style: TextStyle(
                    color: (currentWidth != 200) ? Colors.black : Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// TODO: Implement type face selector
class _TypefaceSelector extends StatelessWidget {
  const _TypefaceSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget typeface = Row(
      children: [
        IconButton(
          onPressed: () => {},
          icon: IconHelper.boldIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => {},
          icon: IconHelper.italicIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => {},
          icon: IconHelper.strikethroughIcon,
          constraints: const BoxConstraints(),
        ),
        IconButton(
          onPressed: () => {},
          icon: IconHelper.underlineIcon,
          constraints: const BoxConstraints(),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Typeface'),
        typeface,
      ],
    );
  }
}

class _FontSelector extends StatelessWidget {
  const _FontSelector(
      {Key? key,
      required this.onFontFamilyChanged,
      required this.onFontSizeChanged,
      this.initialFontFamily,
      this.initialFontSize})
      : super(key: key);

  final void Function(String) onFontFamilyChanged;
  final void Function(double) onFontSizeChanged;
  final String? initialFontFamily;
  final double? initialFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Font'),
        FontPicker(
          onFontFamilyChanged: onFontFamilyChanged,
          onFontSizeChanged: onFontSizeChanged,
          initialFontFamily: initialFontFamily,
          initialFontSize: initialFontSize,
        ),
      ],
    );
  }
}

class _ForegroundColour extends StatelessWidget {
  const _ForegroundColour({Key? key, required this.onColourChanged})
      : super(key: key);

  final void Function(Color) onColourChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Font Colour'),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => ColourPicker(
              onColourChanged: onColourChanged,
            ),
          ),
          icon: IconHelper.colourPickerIcon,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _BackgroundColour extends StatelessWidget {
  const _BackgroundColour({Key? key, required this.onColourChanged})
      : super(key: key);

  final void Function(Color) onColourChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Background Colour'),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => ColourPicker(
              onColourChanged: onColourChanged,
            ),
          ),
          icon: IconHelper.colourPickerIcon,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

// TODO: Implement listing selector
class _ListingSelector extends StatelessWidget {
  const _ListingSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Listing'),
      ],
    );
  }
}

// TODO: Implement text alignemnt selector
class _TextAlignmentSelector extends StatelessWidget {
  const _TextAlignmentSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Text Alignment'),
      ],
    );
  }
}
