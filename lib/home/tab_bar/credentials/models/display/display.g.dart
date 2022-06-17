// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Display _$DisplayFromJson(Map<String, dynamic> json) => Display(
      json['backgroundColor'] as String? ?? '',
      json['icon'] as String? ?? '',
      json['nameFallback'] as String? ?? '',
      json['descriptionFallback'] as String? ?? '',
    );

Map<String, dynamic> _$DisplayToJson(Display instance) => <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'icon': instance.icon,
      'nameFallback': instance.nameFallback,
      'descriptionFallback': instance.descriptionFallback,
    };
