import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/widget/credential_background.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/signature.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/skill.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/app/shared/widget/display_signature.dart';
import 'package:talao/app/shared/widget/skills_list_display.dart';

part 'professional_skill_assessment.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalSkillAssessment extends CredentialSubject {
  @override
  final String id;
  @override
  final String type;
  final List<Skill> skills;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final List<Signature> signatureLines;

  factory ProfessionalSkillAssessment.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalSkillAssessmentFromJson(json);

  ProfessionalSkillAssessment(this.id, this.type, this.skills, this.issuedBy,
      this.signatureLines, this.familyName, this.givenName)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() => _$ProfessionalSkillAssessmentToJson(this);

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    return CredentialBackground(
      model: item,
      child: Column(
        children: [
          CredentialField(title: localizations.lastName, value: givenName),
          CredentialField(title: localizations.firstName, value: familyName),
          SkillsListDisplay(
            skillWidgetList: skills,
          ),
          Column(
            children: signatureLines
                .map((e) =>
                    DisplaySignatures(localizations: localizations, item: e))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DisplayIssuer(
              issuer: issuedBy,
            ),
          ),
        ],
      ),
    );
  }

  static List<Signature> _signatureLinesFromJson(json) {
    if (json == null || json == '') {
      return [];
    }
    if (json is List) {
      return (json)
          .map((e) => Signature.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Signature.fromJson(json)];
  }
}
