import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/learning_achievement/has_credential.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';

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
    return Text('display list certificate');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        CredentialField(value: familyName, title: localizations.firstName),
        CredentialField(title: localizations.lastName, value: givenName),
        CredentialField(title: localizations.personalMail, value: email),
        CredentialField(title: localizations.birthdate, value: birthDate),
        CredentialField(
            title: localizations.learningAchievement,
            value: hasCredential.title),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(hasCredential.description),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DisplayIssuer(
            issuer: issuedBy,
          ),
        )
      ],
    );
  }
}
