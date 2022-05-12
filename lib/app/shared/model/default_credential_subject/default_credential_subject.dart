import 'package:flutter/material.dart';
import 'package:json_path/json_path.dart';
import 'package:talao/app/interop/launch_url/launch_url.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_manifest/display_mapping.dart';
import 'package:talao/app/shared/model/credential_manifest/display_mapping_path.dart';
import 'package:talao/app/shared/model/credential_manifest/display_mapping_text.dart';
import 'package:talao/app/shared/model/credential_manifest/labeled_display_mapping_path.dart';
import 'package:talao/app/shared/model/credential_manifest/labeled_display_mapping_text.dart';
import 'package:talao/app/shared/model/credential_manifest/output_descriptor.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/l10n/l10n.dart';

part 'default_credential_subject.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultCredentialSubject extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;

  factory DefaultCredentialSubject.fromJson(Map<String, dynamic> json) =>
      _$DefaultCredentialSubjectFromJson(json);

  DefaultCredentialSubject(this.id, this.type, this.issuedBy)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$DefaultCredentialSubjectToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final outputDescriptor = item.credentialManifest?.outputDescriptors;
    if (outputDescriptor == null) {
      final localizations = AppLocalizations.of(context)!;

      return CredentialBackground(
        model: item,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: displayName(context, item),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: displayDescription(context, item),
            ),
            item.credentialPreview.evidence.first.id != ''
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          '${localizations.evidenceLabel}: ',
                          style:
                              Theme.of(context).textTheme.credentialFieldTitle,
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () => LaunchUrl.launch(
                                item.credentialPreview.evidence.first.id),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    item.credentialPreview.evidence.first.id,
                                    style: Theme.of(context)
                                        .textTheme
                                        .credentialFieldDescription,
                                    maxLines: 5,
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      );
    } else {
      return CredentialBackground(
        model: item,
        child: Container(
          color: Colors.amber,
          child: OutputDescriptorWidget(outputDescriptor, item),
        ),
      );
    }
  }
}

class OutputDescriptorWidget extends StatelessWidget {
  const OutputDescriptorWidget(this.outputDescriptor, this.item);
  final List<OutputDescriptor> outputDescriptor;
  final CredentialModel item;
  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    outputDescriptor.forEach(((element) => widgets.add(Column(
          children: [
            displayMappingWidget(
              element.display?.title,
              item,
            ),
            displayMappingWidget(
              element.display?.subtitle,
              item,
            ),
            displayMappingWidget(
              element.display?.description,
              item,
            ),
            displayPropertiesWidget(
              element.display?.properties,
              item,
            ),
          ],
        ))));
    return Column(
      children: widgets,
    );
  }
}

Widget displayPropertiesWidget(
    List<DisplayMapping>? properties, CredentialModel item) {
  final widgets = <Widget>[];
  properties?.forEach((element) {
    widgets.add(labeledDisplayMappingWidget(element, item));
  });
  if (widgets.isNotEmpty) {
    return Column(
      children: widgets,
    );
  }
  return SizedBox.shrink();
}

Widget displayMappingWidget(
    DisplayMapping? displayMapping, CredentialModel item) {
  if (displayMapping is DisplayMappingText) {
    return CredentialField(value: displayMapping.text);
  }
  if (displayMapping is DisplayMappingPath) {
    final widgets = <Widget>[];
    displayMapping.path.forEach(((e) {
      final fieldsPath = JsonPath(e);
      fieldsPath
          .read(item.data)
          .map((a) => widgets.add(CredentialField(value: a.value)));
    }));
    if (widgets.isNotEmpty) {
      return Column(
        children: widgets,
      );
    }
    if (displayMapping.fallback != null) {
      return CredentialField(
        value: displayMapping.fallback ?? '',
      );
    }
  }
  return SizedBox.shrink();
}

Widget labeledDisplayMappingWidget(
    DisplayMapping? displayMapping, CredentialModel item) {
  if (displayMapping is LabeledDisplayMappingText) {
    return CredentialField(value: displayMapping.text);
  }
  if (displayMapping is LabeledDisplayMappingPath) {
    final widgets = <Widget>[];
    displayMapping.path.map(((e) {
      final fieldsPath = JsonPath(e);
      fieldsPath.read(item.data).map((a) => widgets.add(CredentialField(
            value: a.value,
            title: displayMapping.label,
          )));
    }));
    if (widgets.isNotEmpty) {
      return Column(
        children: widgets,
      );
    }
    if (displayMapping.fallback != null) {
      return CredentialField(
        value: displayMapping.fallback ?? '',
        title: displayMapping.label,
      );
    }
  }
  return SizedBox.shrink();
}
