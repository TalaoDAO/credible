import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/signature.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/skill.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/translation.dart';

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
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.lastName} '),
              Text('$givenName',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.firstName} '),
              Text('$familyName',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Container(
          height: 100,
          child: ListView.builder(
              itemCount: signatureLines.length,
              itemBuilder: (context, index) {
                final item = signatureLines[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('${localizations.signedBy} '),
                          Text(item.name,
                              style: TextStyle(
                                  inherit: true, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    item.image != ''
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 60,
                              child: Image.network(item.image,
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          (loadingProgress == null)
                                              ? child
                                              : CircularProgressIndicator(),
                                  errorBuilder: (context, error, stackTrace) =>
                                      SizedBox.shrink()),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                );
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DisplayIssuer(
            issuer: issuedBy,
          ),
        ),
      ],
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

  String getTranslation(
      List<Translation> translations, AppLocalizations localizations) {
    var _translation;
    var translated = translations
        .where((element) => element.language == localizations.localeName);
    if (translated.isEmpty) {
      var titi = translations.where((element) => element.language == 'en');
      if (titi.isEmpty) {
        _translation = '';
      } else {
        _translation = titi.single.value;
      }
    } else {
      _translation = translated.single.value;
    }
    return _translation;
  }
}
