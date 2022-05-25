import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/input_descriptor.dart';

part 'presentation_definition.g.dart';

@JsonSerializable(explicitToJson: true)
class PresentationDefinition {
  factory PresentationDefinition.fromJson(Map<String, dynamic> json) =>
      _$PresentationDefinitionFromJson(json);
  @JsonKey(name: 'input_descriptors')
  final InputDescriptor inputDescriptors;

  PresentationDefinition(this.inputDescriptors);

  Map<String, dynamic> toJson() => _$PresentationDefinitionToJson(this);
}
