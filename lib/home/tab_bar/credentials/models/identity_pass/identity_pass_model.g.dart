// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'identity_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdentityPassModel _$IdentityPassModelFromJson(Map<String, dynamic> json) =>
    IdentityPassModel(
      recipient: json['recipient'] == null
          ? null
          : IdentityPassRecipient.fromJson(
              json['recipient'] as Map<String, dynamic>),
      expires: json['expires'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      id: json['id'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$IdentityPassModelToJson(IdentityPassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'recipient': instance.recipient?.toJson(),
      'expires': instance.expires,
    };
