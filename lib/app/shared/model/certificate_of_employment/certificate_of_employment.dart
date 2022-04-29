// ignore_for_file: unused_import

import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/certificate_of_employment/work_for.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/ui/date.dart';
import 'package:talao/app/shared/ui/theme.dart';
import 'package:talao/app/shared/widget/card_animation.dart';
import 'package:talao/app/shared/widget/display_description_card.dart';
import 'package:talao/app/shared/widget/display_name_card.dart';
import 'package:talao/app/shared/widget/image_card_text.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/credentials/widget/credential_container.dart';

part 'certificate_of_employment.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class CertificateOfEmployment extends CredentialSubject {
  @override
  String id;
  @override
  String type;
  @JsonKey(defaultValue: '')
  String familyName;
  @JsonKey(defaultValue: '')
  String givenName;
  @JsonKey(defaultValue: '')
  String startDate;
  WorkFor workFor;
  @JsonKey(defaultValue: '')
  String employmentType;
  @JsonKey(defaultValue: '')
  String jobTitle;
  @JsonKey(defaultValue: '')
  String baseSalary;
  @override
  final Author issuedBy;

  CertificateOfEmployment(
      this.id,
      this.type,
      this.familyName,
      this.givenName,
      this.startDate,
      this.workFor,
      this.employmentType,
      this.jobTitle,
      this.baseSalary,
      this.issuedBy)
      : super(id, type, issuedBy);

  factory CertificateOfEmployment.fromJson(Map<String, dynamic> json) =>
      _$CertificateOfEmploymentFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CertificateOfEmploymentToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return CertificateOfEmploymentRecto(item);
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return CertificateOfEmploymentRecto(item);
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        CardAnimation(
          recto: CertificateOfEmploymentRecto(item),
          verso: CertificateOfEmploymentVerso(
            item: item,
          ),
        ),
      ],
    );
  }
}

class CertificateOfEmploymentRecto extends Recto {
  CertificateOfEmploymentRecto(this.item);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/carte-attestation-employeur-recto.png',
                ))),
        child: AspectRatio(

            /// size from over18 recto picture
            aspectRatio: 575 / 316,
            child: Container(
              height: 316,
              width: 575,
              child: CustomMultiChildLayout(
                delegate:
                    CertificateOfEmploymentRectoDelegate(position: Offset.zero),
                children: [
                  LayoutId(
                    id: 'name',
                    child: DisplayNameCard(
                      item,
                      Theme.of(context)
                          .textTheme
                          .certificateOfEmploymentTitleCard,
                    ),
                  ),
                  LayoutId(
                    id: 'description',
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: 250 * MediaQuery.of(context).size.aspectRatio),
                      child: DisplayDescriptionCard(
                        item,
                        Theme.of(context).textTheme.credentialDescription,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}

class CertificateOfEmploymentVerso extends Verso {
  const CertificateOfEmploymentVerso({Key? key, required this.item});

  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final credentialSubject =
        item.credentialPreview.credentialSubject as CertificateOfEmployment;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                'assets/image/carte-attestation-employeur-verso.png',
              ))),
      child: AspectRatio(

          /// this size comes from law publication about job student card specs
          aspectRatio: 572 / 402,
          child: Container(
              height: 402,
              width: 572,
              child: CustomMultiChildLayout(
                delegate:
                    CertificateOfEmploymentVersoDelegate(position: Offset.zero),
                children: [
                  LayoutId(
                    id: 'name',
                    child: DisplayNameCard(
                      item,
                      Theme.of(context)
                          .textTheme
                          .certificateOfEmploymentTitleCard,
                    ),
                  ),
                  LayoutId(
                      id: 'familyName',
                      child: Row(
                        children: [
                          ImageCardText(
                            text: '${localizations.personalLastName}: ',
                            textStyle: Theme.of(context)
                                .textTheme
                                .certificateOfEmploymentData
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          ImageCardText(
                            text: credentialSubject.familyName,
                            textStyle: Theme.of(context)
                                .textTheme
                                .certificateOfEmploymentData,
                          ),
                        ],
                      )),
                  LayoutId(
                    id: 'givenName',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.personalFirstName}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: credentialSubject.givenName,
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData,
                        ),
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'workFor',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.workFor}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: credentialSubject.workFor.name,
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData,
                        ),
                        SizedBox(width: 20),
                        (credentialSubject.workFor.logo != '')
                            ? Container(
                                height: 17,
                                child: ImageFromNetwork(
                                    credentialSubject.workFor.logo))
                            : SizedBox.shrink()
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'startDate',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.startDate}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: UiDate.displayDate(
                              localizations, credentialSubject.startDate),
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData,
                        ),
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'jobTitle',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.jobTitle}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: credentialSubject.jobTitle,
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData,
                        ),
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'employmentType',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.employmentType}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: credentialSubject.employmentType,
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData,
                        ),
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'baseSalary',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.baseSalary}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: credentialSubject.baseSalary,
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData,
                        ),
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'issuanceDate',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.issuanceDate}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: UiDate.displayDate(localizations,
                              item.credentialPreview.issuanceDate),
                          textStyle: Theme.of(context)
                              .textTheme
                              .certificateOfEmploymentData,
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}

class CertificateOfEmploymentVersoDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  CertificateOfEmploymentVersoDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.12));
    }
    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
          'familyName', Offset(size.width * 0.06, size.height * 0.34));
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.06, size.height * 0.25));
    }

    if (hasChild('jobTitle')) {
      layoutChild('jobTitle', BoxConstraints.loose(size));
      positionChild('jobTitle', Offset(size.width * 0.06, size.height * 0.43));
    }
    if (hasChild('workFor')) {
      layoutChild('workFor', BoxConstraints.loose(size));
      positionChild('workFor', Offset(size.width * 0.06, size.height * 0.52));
    }

    if (hasChild('startDate')) {
      layoutChild('startDate', BoxConstraints.loose(size));
      positionChild('startDate', Offset(size.width * 0.06, size.height * 0.61));
    }

    if (hasChild('employmentType')) {
      layoutChild('employmentType', BoxConstraints.loose(size));
      positionChild(
          'employmentType', Offset(size.width * 0.06, size.height * 0.70));
    }
    if (hasChild('baseSalary')) {
      layoutChild('baseSalary', BoxConstraints.loose(size));
      positionChild(
          'baseSalary', Offset(size.width * 0.06, size.height * 0.79));
    }
    if (hasChild('issuanceDate')) {
      layoutChild('issuanceDate', BoxConstraints.loose(size));
      positionChild(
          'issuanceDate', Offset(size.width * 0.06, size.height * 0.88));
    }
  }

  @override
  bool shouldRelayout(CertificateOfEmploymentVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class CertificateOfEmploymentRectoDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  CertificateOfEmploymentRectoDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.14));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
          'description', Offset(size.width * 0.06, size.height * 0.33));
    }
  }

  @override
  bool shouldRelayout(CertificateOfEmploymentRectoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
