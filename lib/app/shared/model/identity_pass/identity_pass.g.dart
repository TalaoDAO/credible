// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityPass _$IdentityPassFromJson(Map<String, dynamic> json) {
  return IdentityPass(
    IdentityPassRecipient.fromJson(json['recipient'] as Map<String, dynamic>),
    json['expires'] as String? ?? '',
    CredentialSubject.fromJsonAuthor(json['issuedBy']),
    json['id'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$IdentityPassToJson(IdentityPass instance) =>
    <String, dynamic>{
      'recipient': instance.recipient,
      'expires': instance.expires,
      'issuedBy': instance.issuedBy,
      'id': instance.id,
      'type': instance.type,
    };
