// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
      (json['path'] as List<dynamic>).map((e) => e as String).toList(),
      json['filter'] == null
          ? null
          : Filter.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'path': instance.path,
      'filter': instance.filter?.toJson(),
    };
