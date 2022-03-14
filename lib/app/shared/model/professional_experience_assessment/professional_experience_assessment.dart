import 'package:talao/app/shared/model/credential_model/credential_model.dart';
import 'package:talao/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/review.dart';
import 'package:talao/app/shared/model/signature.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/skill.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/translation.dart';
import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/base/credential_field.dart';
import 'package:talao/app/shared/widget/display_signature.dart';
import 'package:talao/app/shared/widget/skills_list_display.dart';
import 'package:talao/app/shared/widget/star_rating.dart';

part 'professional_experience_assessment.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalExperienceAssessment extends CredentialSubject {
  @override
  final String id;
  final List<Skill> skills;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String description;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String endDate;
  @JsonKey(defaultValue: '')
  final String startDate;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String email;
  @override
  final String type;
  @JsonKey(defaultValue: [])
  final List<Review> review;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final List<Signature> signatureLines;

  factory ProfessionalExperienceAssessment.fromJson(
          Map<String, dynamic> json) =>
      _$ProfessionalExperienceAssessmentFromJson(json);

  ProfessionalExperienceAssessment(
      this.expires,
      this.email,
      this.id,
      this.type,
      this.skills,
      this.title,
      this.endDate,
      this.startDate,
      this.issuedBy,
      this.review,
      this.signatureLines,
      this.familyName,
      this.givenName,
      this.description)
      : super(id, type, issuedBy);

  @override
  Map<String, dynamic> toJson() =>
      _$ProfessionalExperienceAssessmentToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    final localizations = AppLocalizations.of(context)!;
    final _startDate = startDate;
    final _endDate = endDate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CredentialField(title: localizations.lastName, value: givenName),
        CredentialField(title: localizations.firstName, value: familyName),
        CredentialField(title: localizations.jobTitle, value: title),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                '${localizations.from} ',
                style: Theme.of(context).textTheme.credentialFieldTitle,
              ),
              Text(
                '${UiDate.displayDate(localizations, _startDate)}',
                style: Theme.of(context).textTheme.credentialFieldDescription,
              ),
              Text(
                ' ${localizations.to} ',
                style: Theme.of(context).textTheme.credentialFieldTitle,
              ),
              Text(
                '${UiDate.displayDate(localizations, _endDate)}',
                style: Theme.of(context).textTheme.credentialFieldDescription,
              ),
            ],
          ),
        ),
        CredentialField(value: description),
        SkillsListDisplay(
          skillWidgetList: skills,
        ),
        Container(
          height: 150,
          child: ListView.builder(
              itemCount: review.length,
              itemBuilder: (context, index) {
                final item = review[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslation(item.reviewBody, localizations),
                        style: Theme.of(context)
                            .textTheme
                            .professionalExperienceAssessmentRating,
                      ),
                      StarRating(
                        starCount: 5,
                        rating: double.parse(item.reviewRating.ratingValue),
                        onRatingChanged: (_) => null,
                        color: Theme.of(context).colorScheme.star,
                      ),
                    ],
                  ),
                );
              }),
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
