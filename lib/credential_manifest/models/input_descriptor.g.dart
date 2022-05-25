// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_descriptor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputDescriptor _$InputDescriptorFromJson(Map<String, dynamic> json) =>
    InputDescriptor(
      json['constraints'] == null
          ? null
          : Constraints.fromJson(json['constraints'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InputDescriptorToJson(InputDescriptor instance) =>
    <String, dynamic>{
      'constraints': instance.constraints?.toJson(),
    };
