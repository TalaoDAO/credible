import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/filter.dart';

part 'field.g.dart';

@JsonSerializable(explicitToJson: true)
class Field {
  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  final List<String> path;
  final Filter? filter;

  Field(this.path, this.filter);

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}
