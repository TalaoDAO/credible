import 'package:talao/app/pages/credentials/models/credential.dart';
import 'package:talao/app/shared/model/author.dart';
import 'package:talao/app/shared/model/credential_subject.dart';
import 'package:talao/app/shared/model/professional_experience_assessment/skill.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'professional_experience_assessment.g.dart';

@JsonSerializable()
class ProfessionalExperienceAssessment extends CredentialSubject {
  @override
  final String id;
  final List<Skill> skills;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String endDate;
  @JsonKey(defaultValue: '')
  final String startDate;
  final Author author;
  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String email;
  @override
  final String type;

  factory ProfessionalExperienceAssessment.fromJson(
          Map<String, dynamic> json) =>
      _$ProfessionalExperienceAssessmentFromJson(json);

  ProfessionalExperienceAssessment(this.expires, this.email, this.id, this.type,
      this.skills, this.title, this.endDate, this.startDate, this.author)
      : super(id, type);

  @override
  Map<String, dynamic> toJson() =>
      _$ProfessionalExperienceAssessmentToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return Text('display list identity');
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(id),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(expires),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(email),
        ),
      ],
    );
  }
}
