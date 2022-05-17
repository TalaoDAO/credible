import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/display_mapping.dart';
import 'package:talao/credential_manifest/models/schema.dart';

part 'display_mapping_path.g.dart';

@JsonSerializable(explicitToJson: true)
class DisplayMappingPath extends DisplayMapping {
  DisplayMappingPath(this.path, this.schema, this.fallback);
  factory DisplayMappingPath.fromJson(Map<String, dynamic> json) =>
      _$DisplayMappingPathFromJson(json);

  final List<String> path;
  final Schema schema;
  final String? fallback;

  @override
  Map<String, dynamic> toJson() => _$DisplayMappingPathToJson(this);
}
