// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialModel _$CredentialModelFromJson(Map<String, dynamic> json) {
  return CredentialModel(
    id: CredentialModel.fromJsonId(json['id']),
    alias: json['alias'] as String?,
    image: json['image'] as String?,
    data: json['data'] as Map<String, dynamic>,
    shareLink: json['shareLink'] as String? ?? '',
    display: CredentialModel.fromJsonDisplay(json['display']),
    credential: Credential.fromJson(json['credential'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CredentialModelToJson(CredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'image': instance.image,
      'data': instance.data,
      'shareLink': instance.shareLink,
      'display': instance.display,
      'credential': instance.credential,
    };
