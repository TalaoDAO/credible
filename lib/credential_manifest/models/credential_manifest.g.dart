// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialManifest _$CredentialManifestFromJson(Map<String, dynamic> json) =>
    CredentialManifest(
      json['id'] as String,
      (json['output_descriptors'] as List<dynamic>)
          .map((e) => OutputDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['presentation_definition'] == null
          ? null
          : PresentationDefinition.fromJson(
              json['presentation_definition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CredentialManifestToJson(CredentialManifest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'output_descriptors':
          instance.outputDescriptors.map((e) => e.toJson()).toList(),
      'presentation_definition': instance.presentationDefinition?.toJson(),
    };
