// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailPass _$EmailPassFromJson(Map<String, dynamic> json) => EmailPass(
      json['expires'] as String? ?? '',
      json['email'] as String? ?? '',
      json['id'] as String,
      json['type'] as String,
      CredentialSubject.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$EmailPassToJson(EmailPass instance) => <String, dynamic>{
      'expires': instance.expires,
      'email': instance.email,
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy.toJson(),
    };
