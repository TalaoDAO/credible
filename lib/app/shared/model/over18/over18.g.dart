// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over18.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over18 _$Over18FromJson(Map<String, dynamic> json) => Over18(
      json['id'] as String,
      json['type'] as String,
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$Over18ToJson(Over18 instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy.toJson(),
    };
