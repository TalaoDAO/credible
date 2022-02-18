import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter/material.dart';

class ThemeItem extends StatelessWidget {
  final bool isTrue;
  final String title;
  final VoidCallback onTap;

  const ThemeItem({
    Key? key,
    this.isTrue = false,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: Material(
        color: Theme.of(context).colorScheme.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.borderColor,
                  width: 0.4,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: isTrue
                        ? Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            )
                        : Theme.of(context).textTheme.bodyText1!,
                  ),
                ),
                const SizedBox(width: 16.0),
                if (isTrue)
                  Icon(
                    Icons.radio_button_checked,
                    size: 24.0,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    size: 24.0,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
