import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType type;
  final TextCapitalization textCapitalization;
  final String? error;

  const BaseTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.icon = Icons.edit,
    this.type = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: UiConstraints.textFieldPadding,
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: UiConstraints.textFieldRadius,
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: type,
        maxLines: 1,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          fillColor: Theme.of(context).primaryColor,
          hoverColor: Theme.of(context).primaryColor,
          focusColor: Theme.of(context).primaryColor,
          errorText: error,
          hintText: label,
          hintStyle: Theme.of(context).textTheme.bodyText1!,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodyText1!,
          suffixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
