import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/field.dart';

part 'constraints.g.dart';

@JsonSerializable(explicitToJson: true)
class Constraints {
  factory Constraints.fromJson(Map<String, dynamic> json) =>
      _$ConstraintsFromJson(json);

  final List<Field>? fields;

  Constraints(this.fields);

  Map<String, dynamic> toJson() => _$ConstraintsToJson(this);
}
