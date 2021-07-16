import 'package:json_annotation/json_annotation.dart';

part 'professional_experience_assessment_recipient.g.dart';

@JsonSerializable()
class ProfessionalExperienceAssessmentRecipient {
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String type;

  factory ProfessionalExperienceAssessmentRecipient.fromJson(
          Map<String, dynamic> json) =>
      _$ProfessionalExperienceAssessmentRecipientFromJson(json);

  ProfessionalExperienceAssessmentRecipient(this.name, this.type);

  Map<String, dynamic> toJson() =>
      _$ProfessionalExperienceAssessmentRecipientToJson(this);
}
