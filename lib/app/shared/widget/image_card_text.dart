/// This widget is used to adapt text size on image card when user change phone orientation

import 'package:flutter/material.dart';

class ImageCardText extends StatelessWidget {
  const ImageCardText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: MediaQuery.of(context).orientation == Orientation.landscape
            ? Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: Theme.of(context).textTheme.bodyText2!.fontSize! *
                    MediaQuery.of(context).size.aspectRatio)
            : Theme.of(context).textTheme.bodyText2);
  }
}
