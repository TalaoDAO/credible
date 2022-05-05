// ignore_for_file: unused_import

import 'package:talao/app/interop/launch_url/launch_url.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/card_animation.dart';
import 'package:talao/app/shared/widget/display_description_card.dart';
import 'package:talao/app/shared/widget/display_name_card.dart';
import 'package:talao/app/shared/widget/image_card_text.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/credentials/widget/credential_container.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/learning_achievement/has_credential.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:url_launcher/url_launcher.dart';

part 'learning_achievement.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LearningAchievement extends CredentialSubject {
  @override
  String id;
  @override
  String type;
  @JsonKey(defaultValue: '')
  String familyName;
  @JsonKey(defaultValue: '')
  String givenName;
  @JsonKey(defaultValue: '')
  String email;
  @JsonKey(defaultValue: '')
  String birthDate;
  HasCredential hasCredential;
  @override
  final Author issuedBy;

  LearningAchievement(this.id, this.type, this.familyName, this.givenName,
      this.email, this.birthDate, this.hasCredential, this.issuedBy)
      : super(id, type, issuedBy);

  factory LearningAchievement.fromJson(Map<String, dynamic> json) =>
      _$LearningAchievementFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LearningAchievementToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: LearningAchievementRecto(item));
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: LearningAchievementRecto(item));
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(

            /// this size comes from law publication about job student card specs
            aspectRatio: 572 / 315,
            child: Container(
              height: 315,
              width: 572,
              child: CardAnimation(
                recto: LearningAchievementRecto(item),
                verso: LearningAchievementVerso(
                  item: item,
                ),
              ),
            )),
      ],
    );
  }
}

class LearningAchievementRecto extends Recto {
  LearningAchievementRecto(this.item);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    return CredentialContainer(
      child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    'assets/image/carte-diplome-recto.png',
                  ))),
          child: AspectRatio(

              /// size from over18 recto picture
              aspectRatio: 572 / 315,
              child: Container(
                height: 315,
                width: 572,
                child: CustomMultiChildLayout(
                  delegate:
                      LearningAchievementVersoDelegate(position: Offset.zero),
                  children: [
                    LayoutId(
                      id: 'school',
                      child: Text(
                        item.credentialPreview.credentialSubject.issuedBy.name,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.studentCardSchool,
                      ),
                    ),
                    LayoutId(
                      id: 'name',
                      child: DisplayNameCard(
                        item,
                        Theme.of(context).textTheme.credentialTitleCard,
                      ),
                    ),
                    LayoutId(
                      id: 'description',
                      child: Padding(
                        padding: EdgeInsets.only(
                            right:
                                250 * MediaQuery.of(context).size.aspectRatio),
                        child: DisplayDescriptionCard(
                          item,
                          Theme.of(context)
                              .textTheme
                              .credentialStudentCardTextCard,
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}

class LearningAchievementVerso extends Verso {
  const LearningAchievementVerso({Key? key, required this.item});

  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final credentialSubject =
        item.credentialPreview.credentialSubject as LearningAchievement;

    return CredentialContainer(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/carte-diplome-verso.png',
                ))),
        child: AspectRatio(

            /// this size comes from law publication about job student card specs
            aspectRatio: 572 / 315,
            child: Container(
                height: 315,
                width: 572,
                child: CustomMultiChildLayout(
                  delegate: LearningAchievementDelegate(position: Offset.zero),
                  children: [
                    LayoutId(
                      id: 'name',
                      child: DisplayNameCard(
                        item,
                        Theme.of(context).textTheme.credentialTitleCard,
                      ),
                    ),
                    LayoutId(
                      id: 'school',
                      child: Text(
                        item.credentialPreview.credentialSubject.issuedBy.name,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.studentCardSchool,
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
                                  .studentCardData
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            ImageCardText(
                              text: credentialSubject.familyName,
                              textStyle:
                                  Theme.of(context).textTheme.studentCardData,
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
                                .studentCardData
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          ImageCardText(
                            text: credentialSubject.givenName,
                            textStyle:
                                Theme.of(context).textTheme.studentCardData,
                          ),
                        ],
                      ),
                    ),
                    LayoutId(
                      id: 'birthDate',
                      child: Row(
                        children: [
                          ImageCardText(
                            text: '${localizations.birthdate}: ',
                            textStyle: Theme.of(context)
                                .textTheme
                                .studentCardData
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          ImageCardText(
                            text: UiDate.displayDate(
                                localizations, credentialSubject.birthDate),
                            textStyle:
                                Theme.of(context).textTheme.studentCardData,
                          ),
                        ],
                      ),
                    ),
                    LayoutId(
                      id: 'hasCredential',
                      child: Row(
                        children: [
                          ImageCardText(
                            text: '${credentialSubject.hasCredential.title}: ',
                            textStyle: Theme.of(context)
                                .textTheme
                                .studentCardData
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          ImageCardText(
                            text: credentialSubject.hasCredential.description,
                            textStyle:
                                Theme.of(context).textTheme.studentCardData,
                          ),
                        ],
                      ),
                    ),
                    LayoutId(
                      id: 'proof',
                      child: Row(
                        children: [
                          ImageCardText(
                            text: '${localizations.proof}: ',
                            textStyle: Theme.of(context)
                                .textTheme
                                .studentCardData
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () => LaunchUrl.launch(
                                item.credentialPreview.evidence.first.id),
                            child: ImageCardText(
                              text: item.credentialPreview.evidence.first.id,
                              textStyle:
                                  Theme.of(context).textTheme.studentCardData,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}

class LearningAchievementDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  LearningAchievementDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.16));
    }
    if (hasChild('school')) {
      layoutChild('school', BoxConstraints.loose(size));
      positionChild('school', Offset(size.width * 0.06, size.height * 0.33));
    }

    if (hasChild('familyName')) {
      layoutChild('familyName', BoxConstraints.loose(size));
      positionChild(
          'familyName', Offset(size.width * 0.06, size.height * 0.63));
    }
    if (hasChild('givenName')) {
      layoutChild('givenName', BoxConstraints.loose(size));
      positionChild('givenName', Offset(size.width * 0.06, size.height * 0.53));
    }

    if (hasChild('birthDate')) {
      layoutChild('birthDate', BoxConstraints.loose(size));
      positionChild('birthDate', Offset(size.width * 0.45, size.height * 0.53));
    }

    if (hasChild('hasCredential')) {
      layoutChild('hasCredential', BoxConstraints.loose(size));
      positionChild(
          'hasCredential', Offset(size.width * 0.45, size.height * 0.63));
    }

    if (hasChild('proof')) {
      layoutChild('proof', BoxConstraints.loose(size));
      positionChild('proof', Offset(size.width * 0.06, size.height * 0.8));
    }
  }

  @override
  bool shouldRelayout(LearningAchievementDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class LearningAchievementVersoDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  LearningAchievementVersoDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.16));
    }
    if (hasChild('school')) {
      layoutChild('school', BoxConstraints.loose(size));
      positionChild('school', Offset(size.width * 0.06, size.height * 0.33));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
          'description', Offset(size.width * 0.06, size.height * 0.49));
    }
  }

  @override
  bool shouldRelayout(LearningAchievementVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
