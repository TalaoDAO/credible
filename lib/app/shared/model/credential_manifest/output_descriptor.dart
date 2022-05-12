import 'package:json_annotation/json_annotation.dart';
import 'package:talao/app/shared/model/credential_manifest/display_object.dart';
import 'package:talao/app/shared/model/credential_manifest/styles.dart';

part 'output_descriptor.g.dart';

@JsonSerializable(explicitToJson: true)
class OutputDescriptor {
  OutputDescriptor(
    this.id,
    this.schema,
    this.name,
    this.description,
    this.styles,
    this.display,
  );

  factory OutputDescriptor.fromJson(Map<String, dynamic> json) =>
      _$OutputDescriptorFromJson(json);

  final String id;
  final String schema;
  final String? name;
  final String? description;
  final Styles? styles;
  final DisplayObject? display;

  Map<String, dynamic> toJson() => _$OutputDescriptorToJson(this);
}
