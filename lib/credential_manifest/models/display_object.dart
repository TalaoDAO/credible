import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/display_mapping.dart';
import 'package:talao/credential_manifest/models/display_mapping_path.dart';
import 'package:talao/credential_manifest/models/display_mapping_text.dart';
import 'package:talao/credential_manifest/models/labeled_display_mapping_text.dart';
import 'package:talao/credential_manifest/models/labeled_display_mapping_path.dart';

part 'display_object.g.dart';

@JsonSerializable(explicitToJson: true)
class DisplayObject {
  DisplayObject(this.title, this.subtitle, this.description, this.properties);

  factory DisplayObject.fromJson(Map<String, dynamic> json) =>
      _$DisplayObjectFromJson(json);

  @JsonKey(fromJson: _displayMappingFromJson)
  final DisplayMapping? title;
  @JsonKey(fromJson: _displayMappingFromJson)
  final DisplayMapping? subtitle;
  @JsonKey(fromJson: _displayMappingFromJson)
  final DisplayMapping? description;
  @JsonKey(fromJson: _labeledDisplayMappingFromJson)
  final List<DisplayMapping>? properties;

  Map<String, dynamic> toJson() => _$DisplayObjectToJson(this);

  static List<DisplayMapping>? _labeledDisplayMappingFromJson(json) {
    if (json == null || json == '') {
      return null;
    }
    if (json is List) {
      return (json).map((e) {
        if (e['text'] == null) {
          return LabeledDisplayMappingPath.fromJson(e);
        }
        return LabeledDisplayMappingText.fromJson(e);
      }).toList();
    }

    if (json['text'] == null) {
      return [LabeledDisplayMappingPath.fromJson(json)];
    }
    return [LabeledDisplayMappingText.fromJson(json)];
  }

  static DisplayMapping? _displayMappingFromJson(json) {
    if (json == null || json == '') {
      return null;
    }
    if (json['text'] == null) {
      return DisplayMappingPath.fromJson(json);
    }
    return DisplayMappingText.fromJson(json);
  }
}
