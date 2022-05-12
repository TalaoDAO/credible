import 'package:json_annotation/json_annotation.dart';

part 'display_mapping.g.dart';

@JsonSerializable(explicitToJson: true)
class DisplayMapping {
  DisplayMapping();
  factory DisplayMapping.fromJson(Map<String, dynamic> json) =>
      _$DisplayMappingFromJson(json);

  Map<String, dynamic> toJson() => _$DisplayMappingToJson(this);
}
