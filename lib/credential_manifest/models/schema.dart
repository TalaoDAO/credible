import 'package:json_annotation/json_annotation.dart';

part 'schema.g.dart';

@JsonSerializable(explicitToJson: true)
class Schema {
  Schema(this.type, this.format);

  factory Schema.fromJson(Map<String, dynamic> json) => _$SchemaFromJson(json);

  final String type;
  final String? format;

  Map<String, dynamic> toJson() => _$SchemaToJson(this);
}
