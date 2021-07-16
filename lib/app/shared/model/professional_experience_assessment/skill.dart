import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class Skill {
  @JsonKey(defaultValue: '', name: '@type')
  final String type;
  @JsonKey(defaultValue: '')
  final String description;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Skill(this.type, this.description);

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
