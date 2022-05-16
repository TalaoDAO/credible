import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/display_mapping.dart';

part 'labeled_display_mapping_text.g.dart';

@JsonSerializable(explicitToJson: true)
class LabeledDisplayMappingText extends DisplayMapping {
  LabeledDisplayMappingText(this.text, this.label);

  factory LabeledDisplayMappingText.fromJson(Map<String, dynamic> json) =>
      _$LabeledDisplayMappingTextFromJson(json);

  final String label;
  final String text;

  @override
  Map<String, dynamic> toJson() => _$LabeledDisplayMappingTextToJson(this);
}
