import 'package:intl/intl.dart';
import 'package:talao/app/pages/credentials/models/credential_model.dart';
import 'package:talao/app/pages/credentials/widget/display_issuer.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/review.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/signature.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/skill.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talao/app/shared/model/translation.dart';
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
      this.givenName)
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
    final _startdate = DateFormat("yyyy-mm-ddThh:mm:ssZ").parse(startDate);
    final _endDate = DateFormat("yyyy-mm-ddThh:mm:ssZ").parse(endDate);
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.jobTitle} '),
              Text('$title',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('${localizations.from} '),
              Text('${DateFormat.yMd().format(_startdate)}',
                  style: TextStyle(inherit: true, fontWeight: FontWeight.w700)),
              Text(' ${localizations.to} '),
              Text('${DateFormat.yMd().format(_endDate)}',
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
                      Text(getTranslation(item.reviewBody, localizations),
                          style: TextStyle(
                              inherit: true, fontWeight: FontWeight.w700)),
                      StarRating(
                          starCount: 5,
                          rating: double.parse(item.reviewRating.ratingValue),
                          onRatingChanged: (_) => null,
                          color: Colors.yellowAccent),
                    ],
                  ),
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
