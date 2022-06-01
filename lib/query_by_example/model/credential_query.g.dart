// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialQuery _$CredentialQueryFromJson(Map<String, dynamic> json) =>
    CredentialQuery(
      (json['reason'] as List<dynamic>?)
              ?.map((e) => Translation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      json['example'] == null
          ? null
          : Example.fromJson(json['example'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CredentialQueryToJson(CredentialQuery instance) =>
    <String, dynamic>{
      'reason': instance.reason?.map((e) => e.toJson()).toList(),
      'example': instance.example?.toJson(),
    };
