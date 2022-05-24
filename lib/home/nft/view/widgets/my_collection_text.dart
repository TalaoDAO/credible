import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MyCollectionText extends StatelessWidget {
  const MyCollectionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      l10n.myCollection,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }
}
