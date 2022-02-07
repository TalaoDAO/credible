import 'package:intl/intl.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/learning_achievement/has_credential.dart';
import 'package:talao/app/shared/model/signature.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/display_signature.dart';
import 'package:talao/app/shared/widget/image_card_text.dart';

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
  HasCredential hasCredential;
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
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display Loyalty card');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    final _height = 1753.0;
    final _width = 1240.0;
    final _aspectRatio = _width / _height;

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
                                            '$givenName $familyName, born $birthDate',
                                        textStyle: TextStyle(
                                            fontSize: 5,
                                            fontWeight: FontWeight.bold)),
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
                                        child: Image.network(
                                            signatureLines.image,
                                            loadingBuilder: (context, child,
                                                    loadingProgress) =>
                                                (loadingProgress == null)
                                                    ? child
                                                    : CircularProgressIndicator(),
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    SizedBox.shrink()),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ))),
            )),
      ],
    );
  }

  static Signature _signatureLinesFromJson(json) {
    return Signature.fromJson(json);
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
