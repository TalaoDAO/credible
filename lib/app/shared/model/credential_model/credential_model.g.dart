// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialModel _$CredentialModelFromJson(Map<String, dynamic> json) =>
    CredentialModel(
      id: CredentialModel.fromJsonId(json['id']),
      alias: json['alias'] as String?,
      image: json['image'] as String?,
      credentialPreview: Credential.fromJson(
          json['credentialPreview'] as Map<String, dynamic>),
      shareLink: json['shareLink'] as String? ?? '',
      display: CredentialModel.fromJsonDisplay(json['display']),
      data: json['data'] as Map<String, dynamic>,
      revocationStatus: $enumDecodeNullable(
              _$RevocationStatusEnumMap, json['revocationStatus']) ??
          RevocationStatus.unknown,
      expirationDate: json['expirationDate'] as String?,
      credentialManifest: CredentialModel.credentialManifestFromJson(
          json['credential_manifest']),
      receivedId:
          CredentialModel.readValueReceivedId(json, 'receivedId') as String?,
      challenge: json['challenge'] as String?,
      domain: json['domain'] as String?,
    );

Map<String, dynamic> _$CredentialModelToJson(CredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receivedId': instance.receivedId,
      'alias': instance.alias,
      'image': instance.image,
      'data': instance.data,
      'shareLink': instance.shareLink,
      'credentialPreview': instance.credentialPreview.toJson(),
      'display': instance.display.toJson(),
      'expirationDate': instance.expirationDate,
      'revocationStatus': _$RevocationStatusEnumMap[instance.revocationStatus],
      'credential_manifest': instance.credentialManifest?.toJson(),
      'challenge': instance.challenge,
      'domain': instance.domain,
    };

const _$RevocationStatusEnumMap = {
  RevocationStatus.active: 'active',
  RevocationStatus.expired: 'expired',
  RevocationStatus.revoked: 'revoked',
  RevocationStatus.unknown: 'unknown',
};
