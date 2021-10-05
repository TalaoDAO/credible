// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhonePass _$PhonePassFromJson(Map<String, dynamic> json) {
  return PhonePass(
    json['expires'] as String? ?? '',
    json['phone'] as String? ?? '',
    json['id'] as String,
    json['type'] as String,
    CredentialSubject.fromJsonAuthor(json['issuedBy']),
  );
}

Map<String, dynamic> _$PhonePassToJson(PhonePass instance) => <String, dynamic>{
      'expires': instance.expires,
      'phone': instance.phone,
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy.toJson(),
    };
