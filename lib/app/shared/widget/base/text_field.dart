import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType type;
  final TextCapitalization textCapitalization;
  final String? error;
  final Widget? prefixIcon;
  final BoxConstraints? prefixConstraint;

  const BaseTextField({
    Key? key,
    this.label,
    required this.controller,
    this.icon = Icons.edit,
    this.type = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.error,
    this.prefixIcon,
    this.prefixConstraint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: UiConstraints.textFieldPadding,
      padding: EdgeInsets.only(
        right: 24.0,
        left: prefixIcon != null ? 0.0 : 24.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.borderColor),
        borderRadius: UiConstraints.textFieldRadius,
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: Theme.of(context).colorScheme.secondaryContainer,
        keyboardType: type,
        maxLines: 1,
        textCapitalization: textCapitalization,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 17),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          fillColor: Theme.of(context).colorScheme.primary,
          hoverColor: Theme.of(context).colorScheme.primary,
          focusColor: Theme.of(context).colorScheme.primary,
          errorText: error,
          // hintText: label,
          // hintStyle: Theme.of(context).textTheme.bodyText1!,
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodyText1!,
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixConstraint,
          suffixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
      ),
    );
  }
}
