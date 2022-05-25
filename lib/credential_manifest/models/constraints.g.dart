// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'constraints.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Constraints _$ConstraintsFromJson(Map<String, dynamic> json) => Constraints(
      (json['fields'] as List<dynamic>?)
          ?.map((e) => Field.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ConstraintsToJson(Constraints instance) =>
    <String, dynamic>{
      'fields': instance.fields?.map((e) => e.toJson()).toList(),
    };
