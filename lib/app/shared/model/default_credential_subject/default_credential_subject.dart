import 'package:flutter/material.dart';
import 'package:talao/app/interop/launch_url/launch_url.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/box_decoration.dart';
import 'package:talao/app/shared/widget/hero_workaround.dart';
import 'package:talao/credential_manifest/ui/get_color_from_credential.dart';
import 'package:talao/credential_manifest/view/display_description_widget.dart';
import 'package:talao/credential_manifest/view/display_issuance_date_widget.dart';
import 'package:talao/credential_manifest/view/display_title_widget.dart';
import 'package:talao/credential_manifest/view/output_descriptor_widget.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/credentials/widget/credential_container.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/credentials/widget/display_status.dart';
import 'package:talao/credentials/widget/list_item.dart';
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
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    final outputDescriptor = item.credentialManifest?.outputDescriptors.first;
    // If outputDescriptor exist, the credential has a credential manifest telling us what to display
    if (outputDescriptor == null) {
      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: item.backgroundColor,
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1.0,
              anchors: <Alignment>[
                Alignment.bottomRight,
              ],
            ),
            child: Material(
              color: Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: displayName(context, item),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 48, child: displayDescription(context, item)),
                    ),
                    DisplayIssuer(
                        issuer:
                            item.credentialPreview.credentialSubject.issuedBy)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      var textColor = getColorFromCredential(
        outputDescriptor.styles?.text,
        Colors.black,
      );

      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getColorFromCredential(
                  outputDescriptor.styles?.background, Colors.white),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1.0,
              anchors: <Alignment>[
                Alignment.bottomRight,
              ],
            ),
            child: Material(
              color: Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DisplayTitleWidget(
                        outputDescriptor.display?.title,
                        item,
                        textColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 48,
                          child: DisplayDescriptionWidget(
                            outputDescriptor.display?.description,
                            item,
                            textColor,
                          )),
                    ),
                    DisplayIssuanceDateWidget(
                      item.credentialPreview.issuanceDate,
                      textColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    final credential = Credential.fromJsonOrDummy(item.data);
    final outputDescriptor = item.credentialManifest?.outputDescriptors.first;
    // If outputDescriptor exist, the credential has a credential manifest telling us what to display
    if (outputDescriptor == null) {
      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: item.backgroundColor,
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1.0,
              anchors: <Alignment>[
                Alignment.bottomRight,
              ],
            ),
            child: Material(
              color: Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeroFix(
                            tag: 'credential/${item.id}/icon',
                            child: CredentialIcon(credential: credential)),
                        SizedBox(height: 16.0),
                        DisplayStatus(item, false),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: displayName(context, item),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 48,
                                child: displayDescription(context, item)),
                          ),
                          DisplayIssuer(
                              issuer: item
                                  .credentialPreview.credentialSubject.issuedBy)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      var textColor =
          getColorFromCredential(outputDescriptor.styles?.text, Colors.black);
      return CredentialContainer(
        child: AspectRatio(
          aspectRatio: 584 / 317,
          child: Container(
            // margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BaseBoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: getColorFromCredential(
                  outputDescriptor.styles?.background, Colors.white),
              shapeColor: Theme.of(context).colorScheme.documentShape,
              value: 1.0,
              anchors: <Alignment>[
                Alignment.bottomRight,
              ],
            ),
            child: Material(
              color: Theme.of(context).colorScheme.transparent,
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HeroFix(
                            tag: 'credential/${item.id}/icon',
                            child: CredentialIcon(credential: credential)),
                        SizedBox(height: 16.0),
                        DisplayStatus(item, false),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: outputDescriptor.display?.title != null
                                ? DisplayTitleWidget(
                                    outputDescriptor.display?.title,
                                    item,
                                    textColor,
                                  )
                                : Text(''),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 48,
                                child: DisplayDescriptionWidget(
                                  outputDescriptor.display?.description,
                                  item,
                                  textColor,
                                )),
                          ),
                          DisplayIssuanceDateWidget(
                            item.credentialPreview.issuanceDate,
                            textColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final outputDescriptor = item.credentialManifest?.outputDescriptors;
    // If outputDescriptor exist, the credential has a credential manifest telling us what to display
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
      return OutputDescriptorWidget(outputDescriptor, item);
    }
  }
}
