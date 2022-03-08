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
  Color messageBackgroundColour = Colors.yellow;
  Color messageForegroundColour = Colors.black;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (widget.message != null) {
      _headerController.text = widget.message!.header;
      _messageController.text = widget.message!.message;
    }

    List<Widget> formOptions = [
      _HeaderInput(
        headerController: _headerController,
        fontFamily: fontFamily,
        fontSize: fontSize,
        backgroundColour: messageBackgroundColour,
        foregroundColour: messageForegroundColour,
      ),
      _MessageInput(
        messageController: _messageController,
        fontFamily: fontFamily,
        fontSize: fontSize,
        backgroundColour: messageBackgroundColour,
        foregroundColour: messageForegroundColour,
      ),
      const _TypefaceSelector(),
      _FontSelector(
          onFontFamilyChanged: onFontFamilyChanged,
          onFontSizeChanged: onFontSizeChanged),
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
        title: widget.message == null ? const Text('Add Message') : const Text('Save Message'),
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
                      await _savePressed();
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
    setState(() => messageForegroundColour = newColour);
  }

  void onBackgroundColourChanged(Color newColour) {
    setState(() => messageBackgroundColour = newColour);
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
        scheduled: false);
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
        scheduled: widget.message!.scheduled);
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
      required this.foregroundColour})
      : super(key: key);

  final TextEditingController headerController;
  final String fontFamily;
  final double fontSize;
  final Color backgroundColour;
  final Color foregroundColour;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: headerController,
      decoration: InputDecoration(
        hintText: 'Header',
        fillColor: backgroundColour,
        filled: true,
      ),
      style: GoogleFonts.getFont(fontFamily,
          fontSize: fontSize, color: foregroundColour),
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
      required this.foregroundColour})
      : super(key: key);

  final TextEditingController messageController;
  final String fontFamily;
  final double fontSize;
  final Color backgroundColour;
  final Color foregroundColour;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: 10,
      controller: messageController,
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
      required this.onFontSizeChanged})
      : super(key: key);

  final void Function(String) onFontFamilyChanged;
  final void Function(double) onFontSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Font'),
        FontPicker(
          onFontFamilyChanged: onFontFamilyChanged,
          onFontSizeChanged: onFontSizeChanged,
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
