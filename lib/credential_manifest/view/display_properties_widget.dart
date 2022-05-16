import 'package:flutter/material.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credential_manifest/models/display_mapping.dart';
import 'package:talao/credential_manifest/view/labeled_display_mapping_widget.dart';

class DisplayPropertiesWidget extends StatelessWidget {
  DisplayPropertiesWidget(this.properties, this.item, this.textColor,
      {Key? key})
      : super(key: key);

  final List<DisplayMapping>? properties;
  final CredentialModel item;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    properties?.forEach((element) {
      widgets.add(LabeledDisplayMappingWidget(
        element,
        item,
        textColor,
      ));
    });
    if (widgets.isNotEmpty) {
      return Column(
        children: widgets,
      );
    }
    return SizedBox.shrink();
  }
}
