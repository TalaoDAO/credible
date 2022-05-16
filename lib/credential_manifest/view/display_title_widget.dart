import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/credential_manifest/helpers/get_text_from_credential.dart';
import 'package:talao/credential_manifest/models/display_mapping.dart';
import 'package:talao/credential_manifest/models/display_mapping_path.dart';
import 'package:talao/credential_manifest/models/display_mapping_text.dart';

class DisplayTitleWidget extends StatelessWidget {
  const DisplayTitleWidget(this.displayMapping, this.item, this.textColor,
      {Key? key})
      : super(key: key);
  final DisplayMapping? displayMapping;
  final CredentialModel item;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final object = displayMapping;
    if (object is DisplayMappingText) {
      return CredentialField(
        value: object.text,
        textColor: textColor,
      );
    }
    if (object is DisplayMappingPath) {
      final textList = <String>[];
      object.path.forEach(((e) {
        textList.addAll(getTextsFromCredential(e, item.data));
      }));
      if (textList.isNotEmpty) {
        return Text(
          textList.first,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: textColor == null
              ? Theme.of(context).textTheme.credentialTitle
              : Theme.of(context)
                  .textTheme
                  .credentialTitle
                  .copyWith(color: textColor),
        );
      }
      if (object.fallback != null) {
        return Text(
          object.fallback ?? '',
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: textColor == null
              ? Theme.of(context).textTheme.credentialTitle
              : Theme.of(context)
                  .textTheme
                  .credentialTitle
                  .copyWith(color: textColor),
        );
      }
    }
    return SizedBox.shrink();
  }
}
