import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/credential_manifest/helpers/get_text_from_credential.dart';
import 'package:talao/credential_manifest/models/display_mapping.dart';
import 'package:talao/credential_manifest/models/display_mapping_path.dart';
import 'package:talao/credential_manifest/models/display_mapping_text.dart';

class DisplayMappingWidget extends StatelessWidget {
  const DisplayMappingWidget(this.displayMapping, this.item, this.textColor,
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
      final widgets = <Widget>[];
      object.path.forEach(((e) {
        final textList = getTextsFromCredential(e, item.data);
        textList.forEach((element) {
          widgets.add(CredentialField(
            value: element,
            textColor: textColor,
          ));
        });
      }));

      if (widgets.isNotEmpty) {
        return Column(
          children: widgets,
        );
      }
      if (object.fallback != null) {
        return CredentialField(
          value: object.fallback ?? '',
          textColor: textColor,
        );
      }
    }
    return SizedBox.shrink();
  }
}
