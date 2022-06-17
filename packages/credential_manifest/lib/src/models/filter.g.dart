// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
      json['type'] as String,
      json['pattern'] as String,
    );

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'type': instance.type,
      'pattern': instance.pattern,
    };
