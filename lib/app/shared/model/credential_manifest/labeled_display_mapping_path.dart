import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/credential_manifest/display_mapping.dart';
import 'package:talao/app/shared/model/credential_manifest/schema.dart';

part 'labeled_display_mapping_path.g.dart';

@JsonSerializable(explicitToJson: true)
class LabeledDisplayMappingPath extends DisplayMapping {
  LabeledDisplayMappingPath(this.path, this.schema, this.fallback, this.label);

  factory LabeledDisplayMappingPath.fromJson(Map<String, dynamic> json) =>
      _$LabeledDisplayMappingPathFromJson(json);

  final String label;
  final List<String> path;
  final Schema schema;
  final String? fallback;

  @override
  Map<String, dynamic> toJson() => _$LabeledDisplayMappingPathToJson(this);
}
