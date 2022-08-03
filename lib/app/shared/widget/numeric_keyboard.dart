import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef KeyboardTapCallback = void Function(String text);

@immutable
class KeyboardUIConfig {
  const KeyboardUIConfig({
    this.digitBorderWidth = 3.5,
    this.digitShape = BoxShape.circle,
    this.keyboardRowMargin = const EdgeInsets.only(top: 15, left: 4, right: 4),
    this.digitInnerMargin = const EdgeInsets.all(24),
    this.keyboardSize,
    this.digitTextStyle,
  });

  //Digits have a round thin borders, [digitBorderWidth] define their thickness
  final double digitBorderWidth;
  final BoxShape digitShape;
  final EdgeInsetsGeometry keyboardRowMargin;
  final EdgeInsetsGeometry digitInnerMargin;
  final TextStyle? digitTextStyle;

  //Size for the keyboard can be define and provided from the app.
  //If it will not be provided the size will be adjusted to a screen size.
  final Size? keyboardSize;
}

class NumericKeyboard extends StatelessWidget {
  NumericKeyboard({
    Key? key,
    required this.keyboardUIConfig,
    required this.onKeyboardTap,
    this.digits,
  }) : super(key: key);

  final KeyboardUIConfig keyboardUIConfig;
  final KeyboardTapCallback onKeyboardTap;
  final _focusNode = FocusNode();
  static String deleteButton = 'keyboard_delete_button';

  //should have a proper order [1...9, 0]
  final List<String>? digits;

  @override
  Widget build(BuildContext context) => _buildKeyboard(context);

  Widget _buildKeyboard(BuildContext context) {
    List<String> keyboardItems = List.filled(10, '0');
    if (digits == null || digits!.isEmpty) {
      keyboardItems = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    } else {
      keyboardItems = digits!;
    }
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = screenSize.height > screenSize.width
        ? screenSize.height / 2
        : screenSize.height - 80;
    final keyboardWidth = keyboardHeight * 3 / 4;
    final keyboardSize = keyboardUIConfig.keyboardSize != null
        ? keyboardUIConfig.keyboardSize!
        : Size(keyboardWidth, keyboardHeight);
    return Container(
      width: keyboardSize.width,
      height: keyboardSize.height,
      margin: const EdgeInsets.only(top: 16),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyUpEvent) {
            if (keyboardItems.contains(event.data.keyLabel)) {
              onKeyboardTap(event.logicalKey.keyLabel);
              return;
            }
            if (event.logicalKey.keyLabel == 'Backspace' ||
                event.logicalKey.keyLabel == 'Delete') {
              onKeyboardTap(NumericKeyboard.deleteButton);
              return;
            }
          }
        },
        child: AlignedGrid(
          keyboardSize: keyboardSize,
          children: List.generate(10, (index) {
            return Container(
              margin: const EdgeInsets.all(4),
              child: keyboardUIConfig.digitShape == BoxShape.circle
                  ? ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            onKeyboardTap(keyboardItems[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: keyboardUIConfig.digitShape,
                              color: Colors.transparent,
                              border: keyboardUIConfig.digitBorderWidth > 0.0
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .digitPrimaryColor,
                                      width: keyboardUIConfig.digitBorderWidth,
                                    )
                                  : null,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .digitFillColor,
                              ),
                              child: Text(
                                keyboardItems[index],
                                style: keyboardUIConfig.digitTextStyle ??
                                    Theme.of(context)
                                        .textTheme
                                        .keyboardDigitTextStyle,
                                semanticsLabel: keyboardItems[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : ClipRect(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Theme.of(context).colorScheme.primary,
                          onTap: () {
                            onKeyboardTap(keyboardItems[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: keyboardUIConfig.digitShape,
                              color: Colors.transparent,
                              border: keyboardUIConfig.digitBorderWidth > 0.0
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .digitPrimaryColor,
                                      width: keyboardUIConfig.digitBorderWidth,
                                    )
                                  : null,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .digitFillColor,
                              ),
                              child: Text(
                                keyboardItems[index],
                                style: keyboardUIConfig.digitTextStyle ??
                                    Theme.of(context)
                                        .textTheme
                                        .keyboardDigitTextStyle,
                                semanticsLabel: keyboardItems[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }
}

class AlignedGrid extends StatelessWidget {
  const AlignedGrid({
    Key? key,
    required this.children,
    required this.keyboardSize,
  })  : listSize = children.length,
        super(key: key);

  static const double runSpacing = 4;
  static const double spacing = 4;
  final int listSize;
  static const columns = 3;
  final List<Widget> children;
  final Size keyboardSize;

  @override
  Widget build(BuildContext context) {
    final primarySize = keyboardSize.width > keyboardSize.height
        ? keyboardSize.height
        : keyboardSize.width;
    final itemSize = (primarySize - runSpacing * (columns - 1)) / columns;
    return Wrap(
      runSpacing: runSpacing,
      spacing: spacing,
      alignment: WrapAlignment.center,
      children: children
          .map(
            (item) => SizedBox(
              width: itemSize,
              height: itemSize,
              child: item,
            ),
          )
          .toList(growable: false),
    );
  }
}
