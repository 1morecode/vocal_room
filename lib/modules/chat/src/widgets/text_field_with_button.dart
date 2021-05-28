import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

class TextFieldWithButton extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onSubmit;
  final Function onEmojiTap;
  final bool showEmojiKeyboard;
  final BuildContext context;

  TextFieldWithButton({
    @required this.context,
    @required this.textEditingController,
    @required this.onSubmit,
    this.onEmojiTap,
    this.showEmojiKeyboard = false,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: colorScheme.onPrimary,
            border: Border(
              top: BorderSide(color: colorScheme.secondaryVariant),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: Platform.isIOS
                          ? EdgeInsets.only(left: 5, right: 5)
                          : EdgeInsets.only(left: 5, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: colorScheme.onSurface,
                        border: Border.all(
                          width: 1,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Platform.isIOS
                              ? Container()
                              : CupertinoButton(
                                  padding: EdgeInsets.all(5),
                                  onPressed: () {
                                    onEmojiTap(showEmojiKeyboard);
                                  },
                                  child: Icon(
                                    Icons.insert_emoticon,
                                    color: colorScheme.secondaryVariant,
                                  ),
                                ),
                          Expanded(
                            child: Scrollbar(
                              child: TextField(
                                autocorrect: true,
                                maxLines: 4,
                                minLines: 1,
                                showCursor: true,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                cursorColor: colorScheme.onSecondary,
                                controller: textEditingController,
                                onSubmitted: (_) {
                                  onSubmit();
                                },
                                onTap: () {
                                  if (showEmojiKeyboard) {
                                    onEmojiTap(showEmojiKeyboard);
                                  }
                                },
                                style: TextStyle(fontSize: 16, color: colorScheme.onSecondary),
                                decoration: InputDecoration(
                                  isDense: true,
                                  // suffixIcon: Icon(Icons.add),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Enter message...',
                                  hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.secondaryVariant,
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: colorScheme.onSecondary
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.all(5),
                    color: colorScheme.primary,
                    onPressed: () {
                      onSubmit();
                    },
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.send_outlined,
                        color: colorScheme.onPrimary,
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        renderEmojiKeyboard(),
      ],
    );
  }

  Widget renderEmojiKeyboard() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (showEmojiKeyboard) {
      FocusScope.of(context).requestFocus(FocusNode());
    }
    if (showEmojiKeyboard && !_keyboardIsVisible()) {
      return EmojiPicker(
        rows: 3,
        columns: 7,
        indicatorColor: colorScheme.primary,
        bgColor: colorScheme.onPrimary,
        onEmojiSelected: (emoji, category) {
          final emojiImage = emoji.emoji;
          textEditingController.text =
              "${textEditingController.text}$emojiImage";
        },
      );
    }
    return Container(width: 0, height: 0);
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }
}
