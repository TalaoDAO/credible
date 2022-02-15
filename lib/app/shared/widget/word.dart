import 'package:flutter/material.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/my_text.dart';

class PhraseWord extends StatelessWidget {
  final int order;
  final String word;

  const PhraseWord({
    Key? key,
    required this.order,
    required this.word,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.transparent,
          border: Border.all(
            width: 1.5,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(128.0),
        ),
        child: MyText(
          '$order $word',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.caption,
        ),
      );
}
