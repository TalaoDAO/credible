import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final Color? textColor;
  final Color? borderColor;
  final BuildContext context;

  const BaseButton({
    required this.child,
    required this.context,
    this.onPressed,
    this.gradient,
    this.textColor,
    this.borderColor,
  });

  BaseButton.white({
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    Color? borderColor,
  }) : this(
          child: child,
          context: context,
          onPressed: onPressed,
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          borderColor: borderColor,
        );

  BaseButton.primary({
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    Gradient? gradient,
    Color? borderColor,
    Color? textColor,
  }) : this(
          child: child,
          context: context,
          onPressed: onPressed,
          gradient: gradient ??
              LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondaryVariant,
                  Theme.of(context).colorScheme.secondaryVariant
                ],
              ),
          textColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
          borderColor: borderColor,
        );

  BaseButton.transparent({
    required Widget child,
    required BuildContext context,
    VoidCallback? onPressed,
    Color? borderColor,
    Color? textColor,
  }) : this(
          child: child,
          context: context,
          onPressed: onPressed,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.transparent,
              Theme.of(context).colorScheme.transparent
            ],
          ),
          textColor: textColor,
          borderColor: borderColor,
        );

  @override
  Widget build(BuildContext context) {
    final gradient = this.gradient ??
        LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondaryVariant,
            Theme.of(context).colorScheme.secondaryVariant
          ],
        );
    final textColor = this.textColor ?? Theme.of(context).colorScheme.button;

    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: UiConstraints.buttonRadius,
        border: borderColor != null
            ? Border.all(
                width: 2.0,
                color: borderColor!,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: UiConstraints.buttonRadius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: UiConstraints.buttonRadius,
          child: Container(
            alignment: Alignment.center,
            padding: UiConstraints.buttonPadding,
            child: DefaultTextStyle(
              style:
                  Theme.of(context).textTheme.button!.apply(color: textColor),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
