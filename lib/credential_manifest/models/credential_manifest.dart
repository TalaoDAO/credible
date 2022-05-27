import 'package:json_annotation/json_annotation.dart';
import 'package:talao/credential_manifest/models/output_descriptor.dart';
import 'package:talao/credential_manifest/models/presentation_definition.dart';

part 'credential_manifest.g.dart';

@JsonSerializable(explicitToJson: true)
class CredentialManifest {
  CredentialManifest(
      this.id, this.outputDescriptors, this.presentationDefinition);

  factory CredentialManifest.fromJson(Map<String, dynamic> json) =>
      _$CredentialManifestFromJson(json);

  final String? id;
  @JsonKey(name: 'output_descriptors')
  final List<OutputDescriptor>? outputDescriptors;
  @JsonKey(
      name: 'presentation_definition', fromJson: presentationDefinitionFromJson)
  final PresentationDefinition? presentationDefinition;

  Map<String, dynamic> toJson() => _$CredentialManifestToJson(this);

  static PresentationDefinition? presentationDefinitionFromJson(json) {
    if (json == null || json['input_descriptors'] == null) {
      return null;
    }
    return PresentationDefinition.fromJson(json);
  }
}
