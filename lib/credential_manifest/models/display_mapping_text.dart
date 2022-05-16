import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/display_mapping.dart';

part 'display_mapping_text.g.dart';

@JsonSerializable(explicitToJson: true)
class DisplayMappingText extends DisplayMapping {
  DisplayMappingText(this.text);

  factory DisplayMappingText.fromJson(Map<String, dynamic> json) =>
      _$DisplayMappingTextFromJson(json);

  final String text;

  @override
  Map<String, dynamic> toJson() => _$DisplayMappingTextToJson(this);
}
