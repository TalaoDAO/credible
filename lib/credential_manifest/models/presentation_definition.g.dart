// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresentationDefinition _$PresentationDefinitionFromJson(
        Map<String, dynamic> json) =>
    PresentationDefinition(
      InputDescriptor.fromJson(
          json['input_descriptors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PresentationDefinitionToJson(
        PresentationDefinition instance) =>
    <String, dynamic>{
      'input_descriptors': instance.inputDescriptors.toJson(),
    };
