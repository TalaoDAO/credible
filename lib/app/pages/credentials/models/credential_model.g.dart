// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialModel _$CredentialModelFromJson(Map<String, dynamic> json) {
  return CredentialModel(
    id: CredentialModel.fromJsonId(json['id']),
    alias: json['alias'] as String?,
    image: json['image'] as String?,
    credentialPreview:
        Credential.fromJson(json['credentialPreview'] as Map<String, dynamic>),
    shareLink: json['shareLink'] as String? ?? '',
    display: CredentialModel.fromJsonDisplay(json['display']),
    data: json['data'] as Map<String, dynamic>,
    revocationStatus: _$enumDecodeNullable(
            _$RevocationStatusEnumMap, json['revocationStatus']) ??
        RevocationStatus.unknown,
  );
}

Map<String, dynamic> _$CredentialModelToJson(CredentialModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'image': instance.image,
      'data': instance.data,
      'shareLink': instance.shareLink,
      'credentialPreview': instance.credentialPreview.toJson(),
      'display': instance.display.toJson(),
      'revocationStatus': _$RevocationStatusEnumMap[instance.revocationStatus],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$RevocationStatusEnumMap = {
  RevocationStatus.active: 'active',
  RevocationStatus.expired: 'expired',
  RevocationStatus.revoked: 'revoked',
  RevocationStatus.unknown: 'unknown',
};
