// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentation_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresentationDefinition _$PresentationDefinitionFromJson(
        Map<String, dynamic> json) =>
    PresentationDefinition(
      (json['input_descriptors'] as List<dynamic>)
          .map((e) => InputDescriptor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PresentationDefinitionToJson(
        PresentationDefinition instance) =>
    <String, dynamic>{
      'input_descriptors':
          instance.inputDescriptors.map((e) => e.toJson()).toList(),
    };
