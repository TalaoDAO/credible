import 'package:flutter/material.dart';

import 'base/button.dart';
import 'base/text_field.dart';

class TextFieldDialog extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? initialValue;
  final String yes;
  final String no;

  const TextFieldDialog(
      {Key? key,
      required this.title,
      this.subtitle,
      this.initialValue,
      this.yes = 'Confirm',
      this.no = 'No'})
      : super(key: key);

  @override
  _TextFieldDialogState createState() => _TextFieldDialogState();
}

class _TextFieldDialogState extends State<TextFieldDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();

    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.only(
        top: 24.0,
        bottom: 16.0,
        left: 24.0,
        right: 24.0,
      ),
      title: Text(
        widget.title,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseTextField(
            label: 'Credential alias',
            controller: controller,
            // icon: Icons.wallet,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24.0),
          Row(
            children: <Widget>[
              Expanded(
                child: BaseButton.transparent(
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop(controller.text);
                  },
                  child: Text(widget.yes),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: BaseButton.primary(
                  context: context,
                  onPressed: () {
                    Navigator.of(context).pop('');
                  },
                  child: Text(
                    widget.no,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
