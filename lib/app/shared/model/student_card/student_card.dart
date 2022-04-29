import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/professional_student_card/professional_student_card_recipient.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/card_animation.dart';
import 'package:talao/app/shared/widget/display_description_card.dart';
import 'package:talao/app/shared/widget/display_name_card.dart';
import 'package:talao/app/shared/widget/image_card_text.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/credentials/widget/credential_container.dart';

part 'student_card.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentCard extends CredentialSubject {
  @JsonKey(fromJson: _fromJsonProfessionalStudentCardRecipient)
  final ProfessionalStudentCardRecipient recipient;
  @JsonKey(defaultValue: '')
  final String expires;
  @override
  final Author issuedBy;
  @override
  final String id;
  @override
  final String type;

  factory StudentCard.fromJson(Map<String, dynamic> json) =>
      _$StudentCardFromJson(json);

  StudentCard(this.recipient, this.expires, this.issuedBy, this.id, this.type)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$StudentCardToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: StudentCardRecto(item));
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return CredentialContainer(child: StudentCardRecto(item));
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
                recto: StudentCardRecto(item),
                verso: StudentCardVerso(
                  recipient: recipient,
                  expires: expires,
                  item: item,
                ),
              ),
            )),
      ],
    );
  }

  static ProfessionalStudentCardRecipient
      _fromJsonProfessionalStudentCardRecipient(json) {
    if (json == null || json == '') {
      return ProfessionalStudentCardRecipient.empty();
    }
    return ProfessionalStudentCardRecipient.fromJson(json);
  }
}

class StudentCardRecto extends Recto {
  StudentCardRecto(this.item);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/image/carte-etudiant-recto.png',
                ))),
        child: AspectRatio(

            /// size from over18 recto picture
            aspectRatio: 572 / 315,
            child: Container(
              height: 315,
              width: 572,
              child: CustomMultiChildLayout(
                delegate: StudentCardVersoDelegate(position: Offset.zero),
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
                          right: 250 * MediaQuery.of(context).size.aspectRatio),
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
            )));
  }
}

class StudentCardVerso extends Verso {
  const StudentCardVerso(
      {Key? key,
      required this.recipient,
      required this.expires,
      required this.item});

  final ProfessionalStudentCardRecipient recipient;
  final String expires;
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                'assets/image/carte-etudiant-verso.png',
              ))),
      child: AspectRatio(

          /// this size comes from law publication about job student card specs
          aspectRatio: 572 / 315,
          child: Container(
              height: 315,
              width: 572,
              child: CustomMultiChildLayout(
                delegate: StudentCardDelegate(position: Offset.zero),
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
                            text: recipient.familyName,
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
                          text: recipient.givenName,
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
                              localizations, recipient.birthDate),
                          textStyle:
                              Theme.of(context).textTheme.studentCardData,
                        ),
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'expires',
                    child: Row(
                      children: [
                        ImageCardText(
                          text: '${localizations.expires}: ',
                          textStyle: Theme.of(context)
                              .textTheme
                              .studentCardData
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ImageCardText(
                          text: UiDate.displayDate(localizations, expires),
                          textStyle:
                              Theme.of(context).textTheme.studentCardData,
                        ),
                      ],
                    ),
                  ),
                  LayoutId(
                    id: 'signature',
                    child: ImageCardText(
                      text: '${localizations.signature}: ',
                      textStyle: Theme.of(context)
                          .textTheme
                          .studentCardData
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  LayoutId(
                    id: 'image',
                    child: Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ImageFromNetwork(
                              recipient.image,
                              fit: BoxFit.fill,
                            ))),
                  )
                ],
              ))),
    );
  }
}

class StudentCardDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  StudentCardDelegate({this.position = Offset.zero});

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
      positionChild('birthDate', Offset(size.width * 0.5, size.height * 0.53));
    }

    if (hasChild('expires')) {
      layoutChild('expires', BoxConstraints.loose(size));
      positionChild('expires', Offset(size.width * 0.5, size.height * 0.63));
    }

    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.06, size.height * 0.8));
    }

    if (hasChild('image')) {
      layoutChild(
          'image',
          BoxConstraints.tightFor(
              width: size.width * 0.23, height: size.height * 0.42));
      positionChild('image', Offset(size.width * 0.74, size.height * 0.06));
    }
  }

  @override
  bool shouldRelayout(StudentCardDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class StudentCardVersoDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  StudentCardVersoDelegate({this.position = Offset.zero});

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
  bool shouldRelayout(StudentCardVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
