import 'package:talao/app/interop/launch_url/launch_url.dart';
import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/ecole_42_learning_achievement/has_credential_ecole_42.dart';
import 'package:talao/app/shared/model/signature.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/image_card_text.dart';
import 'package:talao/app/shared/widget/image_from_network.dart';
import 'package:talao/l10n/l10n.dart';

part 'ecole_42_learning_achievement.g.dart';

@JsonSerializable(explicitToJson: true)
class Ecole42LearningAchievement extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final Signature signatureLines;
  @JsonKey(defaultValue: '')
  final String birthDate;

  @JsonKey(fromJson: _hasCreddentialEcole42FromJson)
  HasCredentialEcole42 hasCredential;
  @JsonKey(defaultValue: '')
  final String familyName;
  @override
  final Author issuedBy;

  factory Ecole42LearningAchievement.fromJson(Map<String, dynamic> json) =>
      _$Ecole42LearningAchievementFromJson(json);

  Ecole42LearningAchievement(this.id, this.type, this.issuedBy, this.givenName,
      this.signatureLines, this.birthDate, this.familyName, this.hasCredential)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$Ecole42LearningAchievementToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final _height = 1753.0;
    final _width = 1240.0;
    final _aspectRatio = _width / _height;
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        AspectRatio(

            /// this size comes from law publication about job student card specs
            aspectRatio: _aspectRatio,
            child: Container(
              height: _height,
              width: _width,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                            'assets/image/certificate-42.png',
                          ))),
                  child: AspectRatio(

                      /// random size, copy from professional student card
                      aspectRatio: _aspectRatio,
                      child: Container(
                        height: _height,
                        width: _width,
                        child: CustomMultiChildLayout(
                          delegate: Ecole42LearningAchievementDelegate(
                              position: Offset.zero),
                          children: [
                            LayoutId(
                                id: 'studentIdentity',
                                child: Row(
                                  children: [
                                    ImageCardText(
                                        text:
                                            '$givenName $familyName, born ${UiDate.displayDate(localizations, birthDate)}',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .ecole42LearningAchievementStudentIdentity),
                                  ],
                                )),
                            LayoutId(
                                id: 'level',
                                child: Row(
                                  children: [
                                    ImageCardText(
                                      text: 'Level ${hasCredential.level}',
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .ecole42LearningAchievementLevel,
                                    ),
                                  ],
                                )),
                            LayoutId(
                              id: 'signature',
                              child: item.image != ''
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80 *
                                            MediaQuery.of(context)
                                                .size
                                                .aspectRatio,
                                        child: ImageFromNetwork(
                                            signatureLines.image),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ))),
            )),
        if (item.credentialPreview.evidence.first.id != '')
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  '${localizations.evidenceLabel}: ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(width: 5),
                Flexible(
                  child: InkWell(
                    onTap: () => LaunchUrl.launch(
                        item.credentialPreview.evidence.first.id),
                    child: Text(
                      '${item.credentialPreview.evidence.first.id.substring(0, 30)}...',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).colorScheme.markDownA,
                            decoration: TextDecoration.underline,
                          ),
                      maxLines: 5,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  static Signature _signatureLinesFromJson(json) {
    if (json == null || json == '') {
      return Signature.emptySignature();
    }
    return Signature.fromJson(json);
  }

  static HasCredentialEcole42 _hasCreddentialEcole42FromJson(json) {
    if (json == null || json == '') {
      return HasCredentialEcole42.emptyCredential();
    }
    return HasCredentialEcole42.fromJson(json);
  }
}

class Ecole42LearningAchievementDelegate extends MultiChildLayoutDelegate {
  final Offset position;

  Ecole42LearningAchievementDelegate({this.position = Offset.zero});

  @override
  void performLayout(Size size) {
    if (hasChild('studentIdentity')) {
      layoutChild('studentIdentity', BoxConstraints.loose(size));
      positionChild(
          'studentIdentity', Offset(size.width * 0.17, size.height * 0.33));
    }
    if (hasChild('signature')) {
      layoutChild('signature', BoxConstraints.loose(size));
      positionChild('signature', Offset(size.width * 0.5, size.height * 0.55));
    }
    if (hasChild('level')) {
      layoutChild('level', BoxConstraints.loose(size));
      positionChild('level', Offset(size.width * 0.605, size.height * 0.3685));
    }
  }

  @override
  bool shouldRelayout(
      covariant Ecole42LearningAchievementDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}

class TextWithVoucherStyle extends StatelessWidget {
  const TextWithVoucherStyle({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    if (value != '') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ImageCardText(
          text: value,
          textStyle: TextStyle(
              inherit: true,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
