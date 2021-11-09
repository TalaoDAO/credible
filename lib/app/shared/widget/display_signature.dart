import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/signature.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DisplaySignatures extends StatelessWidget {
  const DisplaySignatures({
    Key? key,
    required this.localizations,
    required this.item,
  }) : super(key: key);

  final AppLocalizations localizations;
  final Signature item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.signedBy} '),
              Text(item.name,
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        item.image != ''
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  child: Image.network(item.image,
                      loadingBuilder: (context, child, loadingProgress) =>
                          (loadingProgress == null)
                              ? child
                              : CircularProgressIndicator(),
                      errorBuilder: (context, error, stackTrace) =>
                          SizedBox.shrink()),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
